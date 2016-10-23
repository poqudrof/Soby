#!/usr/bin/env ruby

require_relative 'soby'
# require 'soby'

require 'java'
Java::TechLityReaSvgextended::PShapeSVGExtended.TEXT_QUALITY = 2.0

# Propane::App::SKETCH_PATH = __FILE__
# $:.unshift File.dirname(__FILE__)

filename = nil
filename = ARGV[0] if ARGV[0] != nil

screen_id = 0
if ARGV[1] != nil
   screen_id = ARGV[1].to_i
end


$app =  SobyPlayer.new screen_id

sleep 0.2 while not $app.ready?

if filename != nil
  presentation = Soby::load_presentation ARGV[0]
  Soby::start_presentation presentation
end
# Soby::auto_update presentation, __FILE__
