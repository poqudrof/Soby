## re-open the class

class SobyPlayer
  attr_accessor :presentation1, :presentation2

  def custom_setup
    @presentation1 = @prez
    path = presentation_path + "/presentation2.svg"
    @presentation2 = Soby::load_presentation path
  end

end
