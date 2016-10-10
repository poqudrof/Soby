## re-open the class
require 'skatolo'

class SobyPlayer

  ## Required for Skatolo
  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end

  ## To be overriden by the Presentation Code.
  def custom_setup

    @skatolo = Skatolo.new self

    init_gui

    @setup_done = true
  end

  def init_gui
    @button_reset = @skatolo.addButton("reset")
                    .setPosition(100, 100)
                    .setSize(100, 20)
                    .setLabel("Reset Presentation")

    @slider_background = @skatolo.addSlider("background_color")
                         .setPosition(100, 200)
                         .setSize(100, 20)
                         .setRange(120, 255)
                         .setLabel("Background color")
    @has_gui = true
    @skatolo.update
  end

  def remove_gui
    @has_gui = false
    @skatolo.remove("background_color")
    @skatolo.remove("reset")
  end

  def custom_pre_draw
    background 255
    return unless @setup_done

    return if not @has_gui
    background background_color_value
  end


  def reset
    goto_slide 0
    init_gui
    background_color_value = 120
  end

  def custom_post_draw

  end

end
