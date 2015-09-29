require_relative '../lib/soby'


# Give the current folder to Processing.
# Processing::App::SKETCH_PATH = Dir.pwd

Processing::App::SKETCH_PATH = __FILE__
$:.unshift File.dirname(__FILE__)

## Presentation - relative elements

$app =  SobyPlayer.new 1920,1080

sleep 0.2 while not $app.ready?

presentation = Soby::load_presentation 'custom_background.rb', 'dessin.svg'
Soby::auto_update presentation, __FILE__



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
