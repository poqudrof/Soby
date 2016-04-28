 require_relative '../../lib/soby'
# require 'soby'


Processing::App::SKETCH_PATH = __FILE__
$:.unshift File.dirname(__FILE__)


Processing::PShapeSVG.TEXT_QUALITY = 2.0
$app =  SobyPlayer.new 1920,1080

sleep 0.2 while not $app.ready?

presentation = Soby::load_presentation 'background.rb', 'presentation.svg'

# Soby::auto_update presentation, __FILE__
Soby::start_presentation presentation
