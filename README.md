Soby :

[![Gem Version](https://badge.fury.io/rb/soby.svg)](https://badge.fury.io/rb/soby)

Another crazy idea :

Presentation software based on SVG created by Sozi.

### Concept :

* Presentation softwares are cool things.
* Presentation softwares are limited, and creating animations is
  awfully difficult.
* [Processing](http://processing.org) is awesome.
* [Ruby-Processing](https://github.com/jashkenas/ruby-processing) is
  super-awesome, because it is Processing and it can be live and
  interpreted.


The slides can contain anything than can be displayed in Processing (I
plan on correcting some bugs in SVG support in Processing or integrate
Batik...). So it is :
- Images
- Videos
- Cool generative designs.


Like Sozi the presentation software changes the view on a big images.
Animations are supported.
Videos are supported.
Code evaluations are supported.
All within Inkscpe.


#### Issues

It requires a specific version of Processing which enables to load
images from SVG files.
https://github.com/poqudrof/processing


### How to use ?

Install it using rubygems :

`gem install soby`

Clone the repository and try out the examples in the example folder.
For now the examples are for development only.

Please remember this library is in its early development stage. It is
not user friendly yet. 
