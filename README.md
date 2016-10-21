Soby :

[![Gem Version](https://badge.fury.io/rb/soby.svg)](https://badge.fury.io/rb/soby)

Presentation software based on SVG created by Sozi.

### Concept :

* Presentation softwares are cool things.
* Presentation softwares are limited, and creating animations is
  awfully difficult.
* [Processing](http://processing.org) is awesome.
* [JRubyArt](https://github.com/ruby-processing/JRubyArt) is
  super-awesome, because it is Processing and it can be live and
  interpreted.

The slides can contain anything than can be displayed in our [extended
version of Processing](https://github.com/poqudrof/processing/releases/tag/3.0-svg).

So it is :
- Images loaded in code or ebmedded in a SVG.
- Videos using the [Processing video library](https://github.com/processing/processing-video).
- Cool generative designs, coded in scripts or directly in the SVG file.
- Like Sozi the presentation software changes the view on a SVG image created in inkscape.
- Unlike Sozi, it is not self-contained. For now it requires Processing, JRuby and a few ruby gems.

Animations are supported.

It is based on Sozi on a [unmaintained version](https://github.com/senshu/Sozi/releases/tag/13.11). :


### How to use ?  (linux)

 1. Install the latest [custom version](https://github.com/poqudrof/processing/releases) of Processing.  
 2. Install the [processing Video library](https://github.com/processing/processing-video) and GStreamer if you are on linux. 
 2. Install the library: [extended SVG support for processing](https://github.com/poqudrof/SVGExtended)
 3. Install Jruby Art, follow the [instructions](https://github.com/ruby-processing/JRubyArt)
 4. Install Soby using rubygems : `gem install soby`
 5. Clone the repository.
 6. Try out an example: `cd Soby/examples/video ; soby presentation.svg`  . 

Soby can have up to two arguments, the first one is the presentation to load, the second is optional is the screen on which to run the presentation.
Please remember this program is in its early development stage.


### How to use (Windows & Mac)

Follow the same steps as in Linux. I will post instructions once I start doing ruby and JrubyARt on Windows. 

## Example

New example coming soon. 

Example of a presentation done with Soby (and [Skatolo](https://github.com/potioc/Skatolo)):

watch at:  2:40  and 4:20
https://www.youtube.com/watch?v=QhaNQqVbpCQ&index=5&list=PL9T8000j7sJDcOoHA8r18561F3jDXZASN
