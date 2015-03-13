require 'nokogiri'  # for XML.
require 'ruby-processing' 
require 'ostruct'

$:.unshift File.dirname(__FILE__)

require 'java' 
java_import 'java.lang.System'


require 'prez' 
require 'transforms'
require 'presentation'
require 'slide'
require 'cam' 
require 'myVideo'



@app = Sketch.new 
 
# @file =  "final//raster//raster.svg"
# @prez = Presentation.new(@app, @app.sketchPath(@file)); nil;
# @app.set_prez(@prez)

# #$app.background_min 

 
# $app.background_amplitude 5, 15
# $app.background_min 0
# $app.background_max 255
# $app.background_rate 10x0
# $app.color_mode false 
# $app.background_constrain = true

# $app.background_amplitude 4, 5
# $app.background_min 0
# $app.background_max 100
# $app.background_rate 1000
# $app.color_mode true
# $app.background_constrain = true

# $app.reset_background
 
$app.background_constrain = false
