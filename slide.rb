class Slide 

  attr_accessor :next, :previous, :refid, :sequence, :hide, :matrix, :description
  attr_reader :x, :y, :width, :height, :transform, :title ,:id

  # transition states 
  attr_reader :transition_duration_ms, :timeout_ms, :timeout_enable, :transition_profile
  attr_reader :videos, :animations


  def initialize (element)

    ## TODO: assert ?
    return if element == nil 

    attr = element.attributes

    ## Zoom & Path -> not used...
    # @transition_path_hide = attr["transition-path-hide"].value
    # @transition_zoom_percent = attr["transition-zoom-percent"].value
    #Not always set !
    #    @id = attr["id"].value

    @transition_profile = attr["transition-profile"].value
    @transition_duration_ms = attr["transition-duration-ms"].value.to_f
    @timeout_ms = attr["timeout-ms"].value.to_f
    @timeout_enable = attr["timeout-enable"].value  == "true"
    #    @show_in_frame_list = attr["show-in-frame-list"].value

    @clip = attr["clip"].value
    @hide = attr["hide"].value == "true"
    @sequence = attr["sequence"].value.to_i
    @title = attr["title"].value
    @refid = attr["refid"].value

    init_transition_profile

    @videos = []
    @animations = []
    @current_animation = 0
  end

  def is_hidden?
    @hide
 end 


  def init_transition_profile
    case @transition_profile
    when "linear" 
      @transition = Proc.new { |x| x } 
    when "accelerate" 
      @transition = Proc.new { |x| x**3 } 
    when "strong-accelerate"
      @transition = Proc.new { |x| x**5 } 
    when "decelerate" 
      @transition = Proc.new { |x| 1 - Math.pow(1 - x, 3) } 
    when "strong-decelerate" 
      @transition = Proc.new { |x| 1 - Math.pow(1 - x, 5) } 
    when "accelerate-decelerate" 
      @transition = Proc.new { |x|   
        xs = x <= 0.5 ? x : 1 - x
        y = Math.pow(2 * xs, 3) / 2
        x <= 0.5 ? y : 1 - y
      }
    when "strong-decelerate-accelerate"
      @transition = Proc.new { |x| 
        xs = x <= 0.5 ? x : 1 - x
        y = Math.pow(2 * xs, 5) / 2
        x <= 0.5 ? y : 1 - y 
      }
    when  "immediate-beginning"
      @transition = Proc.new { |x| 1 }
    when  "immediate-end"
      @transition = Proc.new { |x| x === 1 ? 1 : 0}
    when "immediate-middle" 
      @transition = Proc.new { |x| x >= 0.5 ? 1 : 0}
      
    else 
      @transition = Proc.new {|x| x }
    end
  end


  def add_video (video)
    @videos << video
  end

  def has_videos?() 
    @videos.size() != 0 
  end 


  def add_animation (id, animation) 
    @animations[id] = animation
  end

  def has_next_animation?() 
    return false if @animations.size == 0 
    return @current_animation < @animations.size
  end 

  def next_animation 
    @current_animation = @current_animation + 1
    @animations[@current_animation -1]
  end

  def has_previous_animation?() 
    return false if @animations.size == 0 
    return @current_animation > 0
  end 

  def previous_animation 
    @current_animation = @current_animation - 1
    @animations[@current_animation]
  end


  def set_geometry (element, matrix)

    @matrix = matrix
    attr = element.attributes

    #    @label = attr["label"].value
    #    @id = attr["id"].value
    @x = attr["x"].value.to_f
    @y = attr["y"].value.to_f
    @width = attr["width"].value.to_f
    @height = attr["height"].value.to_f
    
    @description = element.css("desc").text if element.css("desc").size > 0
    @title = element.css("title").text if element.css("title").size > 0

    ## TODO : check if title != animation and video 

    # Animation & Video are not ruby Code !
    if @title != nil 
      if  @title.match(/animation/) or @title.match(/video/) 
        @description = nil
      end
    end
    
    #eval @description if @description
  end

  def transition x 
    @transition.call x 
  end


  def to_s 
    ["id ",@id.to_s ," ",
     "transition_path_hide ",@transition_path_hide.to_s ," ",
     "transition_profile ",@transition_profile.to_s ," ",
     "transition_zoom_percent ",@transition_zoom_percent.to_s ," ",
     "transition_duration_ms ",@transition_duration_ms.to_s ," ",
     "timeout_ms ",@timeout_ms.to_s ," ",
     "timeout_enable ",@timeout_enable.to_s ," ",
     "show_in_frame_list ",@show_in_frame_list.to_s ," ",
     "clip ",@clip.to_s ," ",
     "hide ",@hide.to_s ," ",
     "sequence ",@sequence.to_s ," ",
     "title ",@title.to_s ," ",
     "refid ",@refid.to_s ," " ].join
  end
end


