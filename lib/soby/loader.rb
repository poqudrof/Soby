require 'ostruct'
require 'base64'
require 'rubygems'
require 'nokogiri'  # for XML.

class PresentationLoader

  include_package 'processing.core'
  include_package 'tech.lity.rea.SVGExtended'

  include Soby

  attr_accessor :pshape, :svg
  attr_reader  :debug, :url, :presentation

  attr_accessor :graphics

  def initialize (app, url)
    @app = app
    @url = url

    @presentation = Presentation.new(app)
    @presentation.url = @url
    load_files
    build_internal
  end

  def load_files
    xml = @app.loadXML(@url)
    @pshape = Java::TechLityReaSvgextended::PShapeSVGExtended.new(xml)

#      PShapeSVGExtended.new(xml)
    @presentation.pshape = @pshape
    @svg = Nokogiri::XML(open(@url)).children[1];
  end

  def build_internal
    puts "Svg null, look for the error... !"  if @svg == nil
    return if @svg == nil

    load_code
    load_frames
    load_videos
    load_animations
  end

  def load_code
    puts "Loading the code..."

    @svg.css("text").each do |text|

      return if text.attributes["id"] == nil
      id = text.attributes["id"].value       #get the id

      title = text.css("title")
      next if title == nil

      is_code = title.text.match(/code/) != nil
      next unless is_code

      files = text.css("desc").text.split("\n")

      if files == nil
        puts "Source not found, check your includes in svg"
        next
      end

      files.each do |file|

        dir = File.dirname(@url)
        abs_file = dir + "/" + file
        puts ("Loading the code: " + abs_file)
        @presentation.add_source abs_file
        load abs_file
      end

      ## Hide the text to the rendering
      @pshape.getChild(id).setVisible(false)
    end

  end

  def load_frames
    puts "Loading the frames..."
    @svg.children.each do |child|
      next unless child.name =~ /frame/

      ## ignore if it references nothing.
      attr = child.attributes
      next if attr["refid"] == nil

      create_slide child
    end # frame
  end

  def create_slide child
    slide = Slide.new(child)

    # get the element associated with each slide...
    @svg.search("[id=" + slide.refid + "]").each do |elem|
      case elem.name
      when "rect", "image"
        add_rect_or_image_frame(elem, slide)
      when "g"
        add_group(elem, slide)
      else
        puts "Slide type not supported ! "  + elem.name
      end # end case
    end # search

  end

  def add_rect_or_image_frame(element, slide)
    id = slide.title
    refid = slide.refid

    # set the geometry &  transformation
    transform = get_global_transform element
    slide.set_geometry(element, transform[0])

    pshape_element = @pshape.getChild(refid)
    # hide the element
    if pshape_element == nil
      puts "Error: rect or Image  ID:  #{refid} not found. CHECK THE PROCESSING VERSION."
    else
      pshape_element.setVisible(!slide.hide) if element.name == "rect"
    end

    ## Debug
    puts "Slide #{id} created from a rect : #{refid}" if element.name == "rect"
    puts "Slide #{id} created from an image: #{refid}" if element.name == "image"
    @presentation.add_slide(slide)
  end


  def add_group(group, slide)

    id = slide.title
    refid = slide.refid


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
    slide.set_geometry(biggest_rect, transform[0])

    # The description (code to excute) might be in the group  and not in the rect.
    ## TODO: check if it should really be the first ?
    desc = group.css("desc").first
    title = group.css("title").first

    if desc != nil
      if title == nil || (title.text.match(/animation/) == nil and title.text.match(/video/) == nil)
        puts "Group Description read #{desc.text}"

        slide.description =  desc.text
      end
    end

    e = @pshape.getChild(rect_id)
    # hide the rect
    if e == nil
      puts "Error: rect ID:  #{rect_id} not found "
    else
      @pshape.getChild(rect_id).setVisible(!slide.hide)
    end

    puts "Slide #{id} created from a group, and the rectangle: #{rect_id}"

    @presentation.add_slide(slide)
  end




  def load_videos
    # Load the videos...
    puts "Loading the videos..."

    @svg.css("rect").each do |rect|

      return if rect.attributes["id"] == nil
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

      video = MyVideo.new(path, @presentation.slides[slide_id], tr[0], tr[1], tr[2])

      if  @presentation.slides[slide_id] == nil
        puts "Error -> The video #{id}  is linked to the slide #{slide_id} which is not found !"
      else

        @presentation.slides[slide_id].add_video(video)
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

      if  @presentation.slides[slide_id] == nil
        puts "Error -> The animation #{id}  is linked to the slide #{slide_id} which is not found !"
      else
        # add the animation
        @presentation.slides[slide_id].add_animation(anim_id, animation)

        # hide the group !
        animation.pshape_elem.setVisible(false) unless animation.pshape_elem == nil
        puts "Animation #{id} loaded with  #{slide_id}"
      end
    end

  end


  class MyVideo

    include_package 'processing.video'
    include_package 'processing.video.Movie'
    include_package 'org.gestreamer.elements'

    attr_reader :matrix, :width, :height, :slide
    attr_accessor :video

    def initialize(path, slide, matrix, width, height)
      @path = path
      @width = width
      @height = height
      @matrix = matrix
      @slide = slide
    end

    def play
      if @video == nil

        absolute_path = Dir.pwd + "/" + @path

        puts ("loading the video : " + absolute_path)
        vid = Movie.new($app, absolute_path)

        vid.play
#        vid = Movie.new($app, @path)
        puts vid, vid.width, vid.height

        @video = vid
        true
      else
        false
      end
    end

  end


  def to_s
    "Presentation loader. "
  end

end
