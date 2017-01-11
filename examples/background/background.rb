## re-open the class

class SobyPlayer

  ## To be overriden by the Presentation Code.
  def custom_setup
    @background_image = loadImage presentation_path + "/data/abstract-bubbles.jpg"
    @font = loadFont presentation_path + "/data/LinLibertine-30.vlw"

    @footer = "Monday, April 1st. -- Important Talk about pranks."

    @setup_done = true
  end

  def custom_pre_draw
    return unless @setup_done
    image(@background_image, 0, 0)

    fill(255, 120)
    textFont(@font, 25)
    rect(80, height - 80, @footer.size * 10 + 100, 50)

    fill(0)
    text(@footer, 100, height - 50)
  end

  def custom_post_draw

  end

end
