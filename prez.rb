# -*- coding: utf-8 -*-

# Give the current folder to Processing.
Processing::App::SKETCH_PATH = __FILE__

# For the other files, we need to load the libraries 
Processing::App::load_library 'video', 'toxiclibscore'


class Sketch < Processing::App

  include_package 'processing.video'
  include_package 'processing.video.Movie'
  include_package 'processing.core'
  include_package 'toxi.geom'

  import 'toxi.geom.Matrix4x4'

  attr_accessor :prez, :prev_cam, :next_cam, :slides
  attr_reader :is_moving, :current_slide_no

#  attr_accessor :background_max_color, :background_min_color, :background_constrain
  attr_accessor :cam

  
  def running? () @is_running  end

  TRANSITION_DURATION = 1000

  # no Border  
  def init 
    super
    removeFrameBorder
  end
  
  def removeFrameBorder
    frame.removeNotify
    frame.setUndecorated true
    frame.addNotify
  end 


  def setup 
    @ready = false
    size 1024, 768, OPENGL

    init_player

    @ready = true
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
  end


  ## To be overriden by the Presentation Code. 
  def preDraw

  end

  def postDraw

  end

  def draw 
    preDraw

    background(255)
    smooth(8)

    shapeMode(CORNER)
    imageMode(CORNER)

    if(running?)
      
      push_matrix

      update_cam
      self.g.modelview.apply(@cam)
#      shape @prez.pshape, 0, 0

      @prez.draw

      pop_matrix
      
      run_slide_code 
#      display_video 
      display_slide_number 
    end

    postDraw
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
    text(@current_slide_no.to_s, 10, 30)
    pop_matrix
  end


  def key_pressed    

    if key == 'g' 
      puts "Garbage"
      System.gc 
    end 

    if keyCode == LEFT 
      prev_slide
    end

    if keyCode == RIGHT
      next_slide
    end
    
    #    puts "slide #{@current_slide_no} "
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


  def load_video (path)
    puts "Loading..."
    Movie.new(self, path)
  end



  def set_prez (prez)

    #    PShape.loadedImages.clear 
    @prez = prez
    @slides = prez.slides
    goto_slide 0
    @is_running = true
    @prez_middle = PVector.new(@prez.width / 2.0, @prez.height / 2.0)

    puts "Presentation size " 
    puts @prez.width
    puts @prez.height


    ## Use a big screenshot of the presentation !
    ## Instead of SVG rendering.

    # The image is rendered once and saved as an image
    ratio = 1
    @svg_image = createGraphics(@prez.width * ratio, @prez.height * ratio)
    @svg_image.beginDraw
    @svg_image.shapeMode(CORNER)
    @svg_image.shape(@prez.pshape, 0, 0, @prez.width, @prez.height)
    @svg_image.endDraw

    #   @view1 = compute_view 1
    #   @next_view = createGraphics(@width, @height)

    view = createGraphics(@width, @height)

    #    view.beginDraw
    # cam = slide_view 1
    # view.g.modelview.apply(cam)
    # view.shapeMode(CORNER)
    # view.shape(@prez.pshape, 0, 0)
    # view.endDraw
    
    @view1 = view
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

    # animation
    if @slides[@current_slide_no].has_next_animation?
      puts "Animation Next " 
      anim = @slides[@current_slide_no].next_animation
      anim.pshape_elem.setVisible(true)
    else
      goto_slide(@current_slide_no + 1) unless is_last_slide
    end

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

    if next_slide > @prez.slides.size 
      puts "No more slides" 
      return
    end

    current_slide = @current_slide_no 
    
    cam = global_view if next_slide == 0
    cam = slide_view(next_slide)  if next_slide > 0   

    # previous next is now old. 
    @prev_cam = @next_cam
    @prev_cam.mat.set(@cam)
    @next_cam = cam

    @current_slide_no = next_slide

    if next_slide == 0
      @transition_duration = TRANSITION_DURATION.to_f
    else
      @transition_duration = @slides[@current_slide_no].transition_duration_ms
    end

    @transition_start_time = millis
    @is_moving = true

  end


  def update_cam 

    return unless @is_moving

    elapsed_time = millis - @transition_start_time
    v = elapsed_time.to_f / @transition_duration.to_f


    v = @slides[@current_slide_no].transition v unless @current_slide_no == 0

    if v > 1  && @is_moving 
      @is_moving = false
      @cam = @prev_cam.lerp(@next_cam, 1)

      # save a copy 
      @prev_cam.mat = @cam.get
      return
    end

    #    puts v
    @cam = @prev_cam.lerp(@next_cam, v)

  end  

  def slide_view (slide_no)

    if slide_no > @prez.slides.size 
      puts "No more slides" 
      return
    end
    
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


