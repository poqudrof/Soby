
class MyVideo
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
      puts ("loading the video : " + @path)
      vid = $app.load_video(@path)
      vid.play
      @video = vid
      true 
    else 
      false
    end
  end

end
