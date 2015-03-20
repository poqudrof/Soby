require 'soby' 

@player = SobyPlayer.new 

## Presentation - relative elements


file = "dessin.svg" 
#require 'custom_background.rb' 

if $app.ready? 
  @prez = Presentation.new($app, $app.sketchPath(file))
  $app.set_prez @prez 
end 




# #$app.background_min 
# $app.background_amplitude 5, 15
# $app.background_min 10
# $app.background_max 20
# $app.background_rate 100
# $app.color_mode false 
# $app.background_constrain = true

# $app.background_amplitude 4, 5
# $app.background_min 0
# $app.background_max 100
# $app.background_rate 1000
# $app.color_mode true
# $app.background_constrain = true

  # $app.reset_background
  
  # $app.background_constrain = false
