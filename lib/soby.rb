# -*- coding: utf-8 -*-

require 'jruby_art'
require 'jruby_art/app'
require 'java'

## Enables objects to become java for introspection in java.

require 'jruby/core_ext'
# Processing::App::SKETCH_PATH = Dir.pwd

# For the other files, we need to load the libraries
Processing::App::load_library 'video', 'toxiclibscore', 'SVGExtended'

require_relative 'soby/transforms'
require_relative 'soby/loader'
require_relative 'soby/presentation'
require_relative 'soby/slide'
require_relative 'soby/cam'
require_relative 'soby/launcher'


class SobyPlayer < Processing::App

  include_package 'processing.core'
  include_package 'toxi.geom'

  import 'toxi.geom.Matrix4x4'

  attr_accessor :prez, :prev_cam, :next_cam, :slides
  attr_reader :is_moving, :current_slide_no

  attr_reader :has_thread
  attr_accessor :thread
  #  attr_accessor :background_max_color, :background_min_color, :background_constrain
  attr_accessor :cam

  def running? () @is_running  end

  TRANSITION_DURATION = 1000

  def initialize(screen_id)
    @screen_id = screen_id
    super()
  end


  # no Border
  def init
    super
    getSurface.getNative.setUndecorated true
  end

  def settings
    # todo: fullscreen ?
    fullScreen P3D, @screen_id
  end

  def setup
    @ready = false

    @width = self.width
    @height = self.height
    init_player

    @custom_setup_done = true
    @ready = true
    @has_thread = false
  end

  def ready?
    @ready
  end

  def init_player
    @prez = nil
    @current_slide_no = 0
    @is_running = false
    init_cameras
  end

  def init_cameras
    # current camera matrix
    @cam = PMatrix3D.new

    # Cameras for movement.
    @prev_cam = Cam.new
    @next_cam = Cam.new
    @is_moving = false
    @current_ratio = 0
  end


  ## To be overriden by the Presentation Code.
  def custom_setup

  end

  def custom_pre_draw
    background(255)
  end

  def custom_post_draw

  end

  def draw
    rect 0, 0, 100, millis / 1000
    if not @custom_setup_done
      custom_setup
      @custom_setup_done = true
    end

    custom_pre_draw

    shapeMode(CORNER)
    imageMode(CORNER)

    if(running?)

      push_matrix

      update_cam
      self.g.modelview.apply(@cam)
      @prez.draw
      @prez.display_videos
      pop_matrix

      run_slide_code
      display_slide_number
    end

    custom_post_draw
  end

  def run_slide_code
    translate 0, 0, 1
    if not @is_moving and @current_slide_no != 0
      desc = @prez.slides[@current_slide_no].description
      if(desc != nil)
        #          puts "EVAL #{desc}"
        eval desc
      end
    end
  end


  def display_slide_number
    # Slide number
    push_matrix
    translate(@width - 40, @height - 45)
    fill(30)
    strokeWeight(3)
    stroke(190)
    ellipseMode(CENTER)
    ellipse(18, 22, 35, 35)
    fill(255)
    noStroke
    textSize(20)
    if @current_slide_no < 10
      translate 2, 0
    else
      translate -3.5, 0
    end 
    text(@current_slide_no.to_s, 10, 30)
    pop_matrix
  end

  def presentation_path
    File.dirname(@prez.url)
  end

  alias :default_display_slide_number :display_slide_number


  def key_pressed

    if key == 'g'
      puts "Garbage"
      Java::JavaLang::System.gc
    end

    return if @prez == nil

    if keyCode == LEFT
      prev_slide
    end

    if keyCode == RIGHT
      next_slide
    end

    if key == 'l'
      # selectInput("Select a file to process:",
      #             "fileSelected",
      #             Java::JavaIo::File.new(SKETCH_ROOT))

      folder = Java::JavaIo::File.new(SKETCH_ROOT)
      fc = Java::javax::swing::JFileChooser.new("Soby Loader")
      fc.set_dialog_title "Select your presentation"
      fc.setFileFilter AppFilter.new
      fc.setCurrentDirectory folder
      success = fc.show_open_dialog(nil)
      if success == Java::javax::swing::JFileChooser::APPROVE_OPTION
        path = fc.get_selected_file.get_absolute_path
        puts "User selected " + path
        presentation = Soby::load_presentation path
        Soby::start_presentation presentation
      else
        puts "No file"
      end
    end

    if key == 'a'
      return if @has_thread
      puts "Thread starting"
      Soby::auto_update self
      @has_thread = true
    end
    
    if key == 'c'
      @frame_number = 1 if @frame_number == nil
      saveFrame "frame-" + @frame_number.to_s + ".png"
      @frame_number = @frame_number + 1
    end
    
    if key == 's'
      Thread::kill @thread if @has_thread
    end
    #    puts "slide #{@current_slide_no} "
  end

  java_signature 'void fileSelected(java.io.File)'
  def fileSelected selection
  end



  def mouse_dragged
    if not @is_moving
      tr = PMatrix3D.new
      tr.translate(mouse_x - pmouse_x, mouse_y - pmouse_y)

      @cam.preApply(tr)
      @next_cam.mat.preApply(tr)
    end
  end

  def mouseWheel(event)
    e = event.getAmount()
    if not @is_moving
      tr = PMatrix3D.new
      tr.translate(mouse_x, mouse_y)
      tr.scale(e < 0 ?  1.05 :  1 / 1.05)
      tr.translate(-mouse_x, -mouse_y)
      @cam.preApply(tr)
    end
  end


  def set_prez (prez)
    current_slide = @current_slide_no

    #    PShape.loadedImages.clear
    @prez = prez
    @slides = prez.slides

    goto_slide current_slide

    @is_running = true
    @prez_middle = PVector.new(@prez.width / 2.0, @prez.height / 2.0)

    puts "Presentation size "
    puts @prez.width
    puts @prez.height

    @custom_setup_done = false
  end

  def compute_view(view, slide_number)
    #    view = createGraphics(@width, @height, P3D)
    #    @next_view = createGraphics(@width, @height)
    view.beginDraw

    cam = slide_view slide_number
    view.g.modelview.apply(cam)
    view.shapeMode(CORNER)
    view.shape(@prez.pshape, 0, 0)
    view.endDraw

    view
  end


  def next_slide
    is_last_slide = @current_slide_no >= @prez.nb_slides
    is_slide_zero = current_slide_no == 0

    # Gloal view
    if is_slide_zero
      goto_slide(@current_slide_no + 1)
      return
    end

    if @slides[@current_slide_no] == nil
      p "ERROR invalid slide"
      p "Try to go to next slide"
      goto_slide(@current_slide_no + 1) unless is_last_slide
      return
    end

    # animation
    if @slides[@current_slide_no].has_next_animation?
      puts "Animation Next "
      anim = @slides[@current_slide_no].next_animation
      anim.pshape_elem.setVisible(true)
      return
    end

    goto_slide(@current_slide_no + 1) unless is_last_slide

  end

  def prev_slide
    return if @current_slide_no <= 0

    if current_slide_no == 0
      goto_slide(@current_slide_no - 1)
      return
    end

    if @slides[@current_slide_no].has_previous_animation?
      puts "Animation Previous "
      anim = @slides[@current_slide_no].previous_animation
      anim.pshape_elem.setVisible(false)
    else
      goto_slide(@current_slide_no - 1)
    end

  end

  def goto_slide (next_slide)

    current_slide = @current_slide_no

    use_global_view =  next_slide == 0 || next_slide > @prez.slides.size

    cam = global_view if use_global_view
    cam = slide_view(next_slide)  if next_slide > 0

    # previous next is now old.
    @prev_cam = @next_cam
    @prev_cam.mat.set(@cam)
    @next_cam = cam

    @current_slide_no = next_slide

    if use_global_view
      @transition_duration = TRANSITION_DURATION.to_f
    else
      @transition_duration = @slides[@current_slide_no].transition_duration_ms
    end

    @transition_start_time = millis
    @is_moving = true
    @current_ratio = 0

    ## trigger the slide_change function (user defined)
    slide_change
  end

  def slide_change

  end


  def update_cam

    return unless @is_moving
    return if @slides.size == 0

    elapsed_time = millis - @transition_start_time
    @current_time_ratio = elapsed_time.to_f / @transition_duration.to_f

    @current_ratio = @slides[@current_slide_no].transition @current_time_ratio unless @current_slide_no == 0

    if (@current_ratio > 1 || @current_time_ratio > 1) && @is_moving
      @is_moving = false
      @cam = @prev_cam.lerp(@next_cam, 1)

      # save a copy
      @prev_cam.mat = @cam.get
      return
    end

    #    puts @current_ratio
    @cam = @prev_cam.lerp(@next_cam, @current_ratio)

  end

  def slide_view (slide_no)

    if slide_no > @prez.slides.size
      puts "No more slides"
      return
    end

    return if @prez.slides[slide_no] == nil

    puts "slide view..." << slide_no.to_s

    # check slide number
    w = @prez.slides[slide_no].width
    h = @prez.slides[slide_no].height
    x = @prez.slides[slide_no].x
    y = @prez.slides[slide_no].y

    sc1 = @width.to_f / w.to_f
    sc2 = @height.to_f / h.to_f

    # scale
    sc = [sc1, sc2].min


    # translate
    dx = ((@width / sc) - w) * 0.5
    dy = ((@height / sc) - h) * 0.5

    cam = Cam.new

    m = PMatrix3D.new
    m.apply @prez.slides[slide_no].matrix
    m.invert

    # Scale
    tr = PMatrix3D.new
    tr.scale(sc)
    m.preApply(tr)
    m.translate(dx, dy)

    # center
    cam.mat = m
    cam

  end


  def global_view
    # ortho(left, right, bottom, top)
    # frustum(left, right, bottom, top, near, far)

    my_scale = find_scale

    # centering
    dx = ((@width / my_scale) - @prez.width) * 0.5
    dy = ((@height / my_scale) - @prez.height) * 0.5

    cam = Cam.new
    cam.scale = my_scale
    # Not necessary : display from the center...
    cam.post_translation.set(dx, dy)
    cam.compute_mat
    cam
  end

  def find_scale
    sc1 = @width / @prez.width
    sc2 = @height / @prez.height
    return [sc1, sc2].min
  end
  private :find_scale

end

## Allow for java introspection
SobyPlayer.become_java!

## TODO: move this somewhere
class AppFilter < Java::javax::swing::filechooser::FileFilter
  def accept fobj
    return true if fobj.canExecute
    return fobj.isDirectory
  end
  def getDescription
    "Applications"
  end
end
