
require 'base64'

class Presentation 

  include_package 'processing.core'
  include_package 'processing.video'

  include Soby 
    
  attr_accessor :geometry, :slides, :pshape, :svg, :transform
  attr_accessor :width, :height, :matrix, :videos
  attr_reader  :nb_slides, :debug

  attr_accessor :graphics

  def initialize (app, url)
    @app = app
    xml = app.loadXML(url)
    @pshape = PShapeSVG.new(xml)
    @svg = Nokogiri::XML(open(url)).children[1];
    @graphics = @app.g
    build_internal

  end

  def width ; @pshape.getWidth; end
  def height ; @pshape.getHeight; end


  def build_internal 

    # Create the frames.. 
    @slides = {}
    @nb_slides = 0

    load_frames
    load_videos
    load_animations
#    load_images_processing
  end

  def draw
    @graphics.shape pshape, 0, 0
#    display_images_processing
    display_videos
  end


  def load_frames

    puts "Loading the frames..."
    @svg.children.each do |child| 
      
      next unless child.name =~ /frame/
      
      refid, id = create_slide(child)
      
      # get the element associated with each slide...
      @svg.search("[id=" + refid + "]").each do |elem|

        case elem.name 
        when "rect", "image"
          add_rect_or_image(elem, id, refid)
        when "g" 
          add_group(elem, id, refid)
        else 
          puts "Slide type not supported ! "  + elem.name
        end # end case
      end # search
    end # frame
  end

  def create_slide(node)
    sl = Slide.new(node)
    refid = sl.refid
    id = sl.title
    @slides[sl.sequence] = sl
    @slides[id] = sl
    @nb_slides = @nb_slides+1
    [refid, id]
  end


  def add_rect_or_image(element, id, refid)
    # set the geometry &  transformation
    transform = get_global_transform element
    @slides[id].set_geometry(element, transform[0])        
    pshape_element = @pshape.getChild(refid)

    # hide the element
    if pshape_element == nil 
      puts "Error: rect or Image  ID:  #{refid} not found. CHECK THE PROCESSING VERSION."
    else
      pshape_element.setVisible(!@slides[id].hide) if element.name == "rect"
    end

    puts "Slide #{id} created from a rect : #{refid}" if element.name == "rect"
    puts "Slide #{id} created from an image: #{refid}" if element.name == "image"
  end
  
  
  def add_group(group, id, refid) 
    
    # TODO: Find the bounding box of any  group..
    # TODO: Hide the whole group ?
    surf_max = 0
    biggest_rect = nil
    
    ## biggest_rect surface..
    group.css("rect").each do |rect|
      #          (group.css("rect") + group.css("image")).each do |rect|
      
      if biggest_rect == nil 
        biggest_rect = rect
      end
      
      surf_rect = rect.attributes["width"].value.to_i \
      * rect.attributes["height"].value.to_i

      if(surf_rect > surf_max) 
        biggest_rect = rect 
        surf_max = surf_rect
      end
    end  # rect.each 
    
    rect_id = biggest_rect.attributes["id"].value
    transform = get_global_transform biggest_rect
    @slides[id].set_geometry(biggest_rect, transform[0])     

    # The description (code to excute) might be in the group  and not in the rect. 
    ## TODO: check if it should really be the first ?
    desc = group.css("desc").first
    title = group.css("title").first

    if desc != nil 
      if title == nil || (title.text.match(/animation/) == nil and title.text.match(/video/) == nil)
        puts "Group Description read #{desc.text}" 

        @slides[id].description =  desc.text
      end
    end

    
    e = @pshape.getChild(rect_id)
    # hide the rect
    if e == nil 
      puts "Error: rect ID:  #{rect_id} not found "
    else
      @pshape.getChild(rect_id).setVisible(!@slides[id].hide)
    end 

    puts "Slide #{id} created from a group, and the rectangle: #{rect_id}"
  end



  def load_images_processing
    puts "Loading the images for Processing."

    @images_processing = [];

    @svg.css("image").each do |image|
      id = image.attributes["id"].value       #get the id 

      # check that we know the type of file.       
      is_data = image.attributes["href"].value.start_with?("data")
      is_link = image.attributes["href"].value.start_with?("file")
      return unless is_data or is_link

      img, transform = load_link_image image if is_link
      img, transform = load_data_image image if is_data

      ## save for manual display
      @images_processing << [img, transform]

      ## try automatic display

      # parent_id = image.parent.attributes["id"].value
      # parent_pshape = @pshape.getChild(parent_id)

      # theShape = @app.createShape 
      # theShape.beginShape
      # theShape.noStroke
      # theShape.texture img
      # theShape.vertex(0, 0, 0, 0, 0)
      # theShape.vertex(transform[1], 0, 0, transform[1], 0)
      # theShape.vertex(transform[1], transform[2], 0, transform[1], transform[2])
      # theShape.vertex(0, transform[2], 0, 0, transform[2])
      # theShape.endShape

      # theShape.setWidth
      # theShape.setName(image.attributes["id"].value)
      # parent_pshape.addChild(theShape)
      
    end
  end

  def load_link_image image
    transform = get_global_transform image

    # remove the file://  at the beginning
    path = image.attributes["href"].value[7..-1]
    puts "Loading ", path
    img = @app.load_image path
    [img, transform]
  end

  def load_data_image image
    transform = get_global_transform image

    # remove the data:image/ at the beginning
    raw = image.attributes["href"].value[11..-1]
    type, data = raw.split(";base64")

    if File.directory?("/dev/shm/")
      name = "/dev/shm/" + random_name + '.' + type
    else
      name = @app.sketch_path + "/" + random_name + '.' + type
    end

    File.open(name, 'wb') do|f|
      f.write(Base64.decode64(data))
    end

    puts "Loading ", name
    img = @app.load_image name

    File.delete name
    [img, transform]
  end

  def random_name 
    (0...8).map { (65 + rand(26)).chr }.join
  end


  def display_images_processing
    # draw the object
    @graphics.imageMode(Processing::App::CORNER)
    @images_processing.each do |image, transfo|
      mat = transfo[0]
      width = transfo[1]
      height = transfo[2]

      @graphics.push_matrix
      @graphics.modelview.apply(mat)
      @graphics.image(image, 0, 0, width, height)
      @graphics.pop_matrix
    end

  end



  def load_videos
    # Load the videos...
    puts "Loading the videos..."
    @playing_videos = []

    @svg.css("rect").each do |rect|
      id = rect.attributes["id"].value       #get the id 

      title = rect.css("title")
      next if title == nil 

      is_video = title.text.match(/video/) != nil 
      next unless is_video
      
      t = rect.css("desc").text.split("\n")
      slide_id = t[0]
      path = t[1]

      puts ("Loading the video : " + path)

      # Get the transformation
      tr = get_global_transform rect 

      video = MyVideo.new(path, @slides[slide_id], tr[0], tr[1], tr[2]) 

      if  @slides[slide_id] == nil 
        puts "Error -> The video #{id}  is linked to the slide #{slide_id} which is not found !" 
      else 

        @slides[slide_id].add_video(video)
        puts "Video #{id} loaded with  #{slide_id}"
      end

      # Hide the rect, and ... TODO replace it with a special object
      #      @pshape.getChild(id).setVisible(false)
    end
  end



  def load_animations

    puts "Loading the animations..."

    @svg.css("*").each do |elem|

      valid = false
      elem.children.each do |child|
        valid = true if child.name == "title" && child.text.match(/animation/)
      end

      next unless valid

      id = elem.attributes["id"].value

      # Get the animation information 
      t = elem.css("desc").text.split("\n")

      # 1. which slide
      # 2. when 
      slide_id = t[0]
      anim_id = t[1].to_i

      animation = OpenStruct.new
      animation.pshape_elem = @pshape.getChild(id)

      puts "Animation found on slide #{slide_id} with element #{animation.pshape_elem}"

      if  @slides[slide_id] == nil 
        puts "Error -> The animation #{id}  is linked to the slide #{slide_id} which is not found !" 
      else 
        # add the animation
        @slides[slide_id].add_animation(anim_id, animation)
        
        # hide the group !
        animation.pshape_elem.setVisible(false) unless animation.pshape_elem == nil
        puts "Animation #{id} loaded with  #{slide_id}"
      end
    end

  end

  def display_videos
    if not @app.is_moving 


      slide_no = @app.current_slide_no

      # # Display the videos
      if slide_no > 0 and  @slides[slide_no].has_videos? 

        puts "Video playing..?"
        # draw the object
        @graphics.imageMode(Processing::App::CORNER)
        
        @slides[slide_no].videos.each do |my_video| 
          @graphics.push_matrix
          @graphics.modelview.apply(my_video.matrix)
          
          # when the video is loaded it is saved... so that the memory can
          # hopefully be freed
          @playing_videos << my_video if my_video.play 
          
          my_video.video.read if my_video.video.available?           
          @graphics.image(my_video.video, 0, 0, my_video.width, my_video.height)
          
          @graphics.pop_matrix
        end # videos.each
        
      else  # has_videos

        ## no video, free some memory 
        @playing_videos.each do |my_video|
          puts "Saving memory. "
          my_video.video.stop
          my_video.video = nil 
          System.gc
        end
        @playing_videos =  []
      end 
    end
  end


  def to_s 
    "Slides #{@slides.size}" 
  end

end 
