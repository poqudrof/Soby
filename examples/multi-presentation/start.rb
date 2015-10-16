 require_relative '../../lib/soby'
# require 'soby'


Processing::App::SKETCH_PATH = __FILE__
$:.unshift File.dirname(__FILE__)

## Presentation - relative elements

Processing::PShapeSVG.TEXT_QUALITY = 2.0
$app =  SobyPlayer.new 1920,1080

sleep 0.2 while not $app.ready?

presentation1 = Soby::load_presentation 'switch.rb', 'presentation1.svg'
presentation2 = Soby::load_presentation 'switch.rb', 'presentation2.svg'

$app.presentation1 = presentation1
$app.presentation2 = presentation2

Soby::auto_update presentation1, __FILE__
