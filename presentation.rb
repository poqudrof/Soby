

class Presentation 

  include_package 'processing.core'

  include Soby 
    
  attr_accessor :geometry, :slides, :pshape, :svg, :transform
  attr_accessor :width, :height, :matrix, :videos
  attr_reader  :nb_slides, :debug

  def initialize (app, url)
    @app = app
    xml = app.loadXML(url)
    @pshape = PShapeSVG.new(xml)
    @svg = Nokogiri::XML(open(url)).children[1];
    build_internal
  end

  def width ; @pshape.getWidth; end
  def height ; @pshape.getHeight; end

  private 

  def build_internal 

    @debug = []
    
    # Create the frames.. 
    @slides = {}
    @nb_slides = 0

    load_frames
    
    load_videos
    load_animations

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


  def load_videos
    # Load the videos...
    puts "Loading the videos..."
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

      # # TODO : error control
      # vid = @app.load_video(path)
      # vid.loop


      # Get the transformation
      tr = get_global_transform rect 
      #      video = MyVideo.new(vid, @slides[slide_id], tr[0], tr[1], tr[2]) 

      video = MyVideo.new(path, @slides[slide_id], tr[0], tr[1], tr[2]) 

      #      puts "try to add a video " + slide_id

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
      #    @svg.css("g").each do |elem|
      #      next if elem.class != Nokogiri::XML::Node
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



  def to_s 
    "Slides #{@slides.size}" 
  end


  # Tests 
  # -> Numeros ? Pas de manquant etc..

end 
