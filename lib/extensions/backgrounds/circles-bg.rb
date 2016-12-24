# coding: utf-8
## re-open the class

require_relative 'circles'

class SobyPlayer

  ## To be overriden by the Presentation Code.
  def custom_setup
    @circles = CirclesBackground.new(self, width, height)
    @setup_done = true
  end

  def custom_pre_draw
    # puts "pre draw " + @setup_done.to_s
    return unless @setup_done


    background 0
    image(@circles.draw, 0, 0, width, height)
  end

  def custom_post_draw
  end

end
