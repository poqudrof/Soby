require 'ostruct'
require 'base64'

class Presentation

  include_package 'processing.core'

  include Soby

  attr_accessor :slides, :pshape
  attr_accessor :width, :height, :matrix, :videos
  attr_reader  :nb_slides, :debug
  attr_reader :source_files
  attr_accessor :url

  attr_accessor :graphics

  def initialize (app)
    @app = app
    @graphics = @app.g
    @slides = {}
    @nb_slides = 0
    @playing_videos = []
    @source_files = []
  end

  def add_source name ; @source_files << name ;  end
  def width ; @pshape.getWidth; end
  def height ; @pshape.getHeight; end

  def draw
    @graphics.shape pshape, 0, 0
#    display_videos
  end

  def add_slide(new_slide)
    puts "Add slide, id " << new_slide.title << " numero " << new_slide.sequence
    @slides[new_slide.sequence] = new_slide
    @slides[new_slide.title] = new_slide
    @nb_slides = @nb_slides+1

    p "Adding a new slide to the presentation", @nb_slides
  end


  def display_videos
    if not @app.is_moving

      slide_no = @app.current_slide_no

      # # Display the videos
      if slide_no > 0 and  @slides[slide_no].has_videos?

        # draw the object
        @graphics.imageMode(Propane::App::CORNER)

        @slides[slide_no].videos.each do |my_video|
          @graphics.push_matrix
          @graphics.modelview.apply(my_video.matrix)

          # when the video is loaded it is saved... so that the memory can
          # hopefully be freed
          @playing_videos << my_video if my_video.play

          ## force reading here..
          my_video.video.read if my_video.video.available?
#          my_video.video.read
          @graphics.image(my_video.video, 0, 0, my_video.width, my_video.height)


          @graphics.pop_matrix
        end # videos.each

      else  # has_videos

        ## no video, free some memory
        @playing_videos.each do |my_video|
          puts "Saving memory. "
          my_video.video.stop
          my_video.video = nil
          Java::JavaLang::System.gc
        end
        @playing_videos =  []
      end
    end
  end


  def to_s
    "Slides #{@slides.size}"
  end

end
