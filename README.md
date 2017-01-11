Soby :

[![Gem Version](https://badge.fury.io/rb/soby.svg)](https://badge.fury.io/rb/soby)

Presentation software based on SVG created by Sozi (legacy version).

## Soby is getting stable

Soby is a presentation software unlike any other. It is for *presentation enthousiats*: it will give you the
freedom you deserve for building presentations. 

The presentations are *planar* very much like [Prezi](https://prezi.com/). Soby takes advantage from the Inkscape plugin 
to create Sozi presentations [Sozi](http://sozi.baierouge.fr/). The plugin is no longer maintained and will be replaced
by our own plugin at some point. 

### Why is Soby so cool ?

* You can make beautiful presentations with [Inkscape](https://inkscape.org/). Inkscape is an
amazing software to create vector graphics. So you can create your slides nearly in a what you see is what you get way.

* You can put 2D and 3D content in you presentation. Soby is a [Processing](http://processing.org) program, so you can 
display 2D and 3D elements as easily as in Processing !
* Soby is made to be hacked and open endend. Every slide or presentation can change the behaviour of Soby !

Our goal is to have user-contributed: 

* Generative backgrounds.  [2 for now]. 
* Shaders for transitions. [1 experimental]
* Animation in slides  [to implement]

We already have cool features: 

* Nearly full support SVG: curves, lines, embedded images, linked images, and text. The project is: [SVGExtended](https://github.com/Rea-lity-Tech/SVGExtended). 
* GUI inside presentations with [Skatolo](https://github.com/poqudrof/Skatolo) and the [gui example](https://github.com/poqudrof/Soby/tree/master/examples/gui)
* Big presentations can be divided in small presentations, each [loading](https://github.com/poqudrof/Soby/tree/master/examples/load-presentation) the next one. 
* Each slide can hade embedded code like in the [generative background](https://github.com/poqudrof/Soby/tree/master/examples/generative_background) example.
* External ruby files can be loaded when the presentation is loaded. 
* Distribution as JRuby Gem. Hopefully soon as a binary.  


### Why is Soby not for everyone yet ? 

* Soby is distributed as Ruby Gem, not everyone can install Processing, JRuby, and the Processing libraries.  Solution -> distribution as a binary. 
* Soby need some advanced use of Inkscape and the Sozi plugin is far from perfect. Solution -> New plugin for Inkscape. We do not plan to create an editor separated from the player. 
* Soby :

[![Gem Version](https://badge.fury.io/rb/soby.svg)](https://badge.fury.io/rb/soby)

Presentation software based on SVG created by Sozi (legacy version).

## Soby is getting stable

Soby is a presentation software unlike any other. It is for *presentation enthousiats*: it will give you the
freedom you deserve for building presentations. 

The presentations are *planar* very much like [Prezi](https://prezi.com/). Soby takes advantage from the Inkscape plugin 
to create Sozi presentations [Sozi](http://sozi.baierouge.fr/). The plugin is no longer maintained and will be replaced
by our own plugin at some point. 

### Why is Soby so cool ?

* You can make beautiful presentations with [Inkscape](https://inkscape.org/). Inkscape is an
amazing software to create vector graphics. So you can create your slides nearly in a what you see is what you get way.

* You can put 2D and 3D content in you presentation. Soby is a [Processing](http://processing.org) program, so you can 
display 2D and 3D elements as easily as in Processing !
* Soby is made to be hacked and open endend. Every slide or presentation can change the behaviour of Soby !

Our goal is to have user-contributed: 

* Generative backgrounds.  [2 for now]. 
* Shaders for transitions. [1 experimental]
* Animation in slides  [to implement]
* Video player. Ours just play the video once. 

We already have cool features: 

* Nearly full support SVG: curves, lines, embedded images, linked images, and text. The project is: [SVGExtended](https://github.com/Rea-lity-Tech/SVGExtended). 
* GUI inside presentations with [Skatolo](https://github.com/poqudrof/Skatolo) and the [gui example](https://github.com/poqudrof/Soby/tree/master/examples/gui)
* Big presentations can be divided in small presentations, each [loading](https://github.com/poqudrof/Soby/tree/master/examples/load-presentation) the next one. 
* Each slide can hade embedded code like in the [generative background](https://github.com/poqudrof/Soby/tree/master/examples/generative_background) example.
* External ruby files can be loaded when the presentation is loaded. 
* Distribution as JRuby Gem. Hopefully soon as a binary.  
* It can be hacked in much more than it is like a game engine.  
* It is completely open source and free and relies only on open source and free software. 

### Why is Soby not for everyone yet ? 

* Not everyone likes planar presentations. (However you can make standard presentations with Soby). 
* Soby is distributed as Ruby Gem, not everyone can install Processing, JRuby, Processing libraries and an Inkscape plugin.  Solution -> distribution as a binary. 
* Soby need some advanced use of Inkscape and the Sozi plugin is far from perfect. Solution -> New plugin for Inkscape. We do not plan to create an editor separated from the player. 
* Soby's force is the possibility to create code for your presentation. Even though Ruby is easy to try, it will require many tutorials to make it accessible for everyone. 
* For many people a presentation is a PowerPoint, for other nothing is better than Beamer.

* It is based on a Sozi [unmaintained version](https://github.com/senshu/Sozi/releases/tag/13.11).

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
jn
New example coming soon. 

Example of a presentation done with Soby (and [Skatolo](https://github.com/potioc/Skatolo)):

watch at:  2:40  and 4:20
https://www.youtube.com/watch?v=QhaNQqVbpCQ&index=5&list=PL9T8000j7sJDcOoHA8r18561F3jDXZASN




