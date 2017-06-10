# -*- coding: utf-8 -*-

require 'jruby_art'
require 'jruby_art/app'
require 'java'

## Enables objects to become java for introspection in java.

require 'jruby/core_ext'
# Processing::App::SKETCH_PATH = Dir.pwd

if not defined? Processing::App::SKETCH_PATH 
  Processing::App::SKETCH_PATH = __FILE__  
  Processing::App::load_library :video, :SVGExtended, :video_event
end

require_relative 'renderer'

class SobyPlayer < Processing::App
  
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
    fullScreen OPENGL, @screen_id
  end

  def setup
    @main_renderer = SobyRenderer.new
    @main_renderer.init self
  end

  def renderer; @main_renderer ; end
  
  def draw
    @main_renderer.begin_draw
    @main_renderer.render
    @main_renderer.end_draw
    image(@main_renderer, 0, 0, width, height)
  end

  def set_prez prez
    @main_renderer.set_prez prez
  end


  def key_pressed(*args)

    @main_renderer.key_actions.each_pair do |key_name, command|
      @main_renderer.instance_eval &command[1] if key == key_name
    end

    if keyCode == LEFT
      @main_renderer.prev_slide
    end

    if keyCode == RIGHT
      @main_renderer.next_slide
    end

  end

  def mouse_dragged (*args)
    @main_renderer.mouse_dragged
  end

  def mouseWheel(event)
    @main_renderer.mouseWheel event
  end

end

