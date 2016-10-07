Gem::Specification.new do |s|
  s.name        = 'soby'
  s.version     = '0.1.0.2'
  s.date        = '2015-10-15'
  s.summary     = "Sozi player !"
  s.description = "Based on Sozi, it plays presentation using JRubyArt."
  s.authors     = ["Jeremy Laviole"]
  s.email       = 'poqudrof@gmail.com'
  s.add_runtime_dependency "nokogiri",  '~> 1.6', '>= 1.6.3'
  s.add_runtime_dependency "jruby_art",  '~> 1.2', '>= 1.2.4'
  s.files       = ["bin/soby", "lib/soby.rb", "lib/soby/cam.rb", "lib/soby/slide.rb", "lib/soby/presentation.rb", "lib/soby/slide.rb", "lib/soby/transforms.rb", "lib/soby/launcher.rb", "lib/soby/loader.rb"]

  s.executables = ["soby"]
  s.post_install_message = %q{Use 'soby presentation.svg 1' to run a presentation file presentation.svg on screen #1 }

  s.homepage    = 'https://github.com/poqudrof/Soby'
  s.license     = 'LGPL'

end
