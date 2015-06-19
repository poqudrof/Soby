Gem::Specification.new do |s|
  s.name        = 'soby'
  s.version     = '0.0.4'
  s.date        = '2015-06-19'
  s.summary     = "Sozi player !"
  s.description = "Based on Sozi, it works plays presentation using Ruby-processing."
  s.authors     = ["Jeremy Laviole"]
  s.email       = 'poqudrof@gmail.com'
  s.add_runtime_dependency "nokogiri",  [">= 1.6.3"]
  s.add_runtime_dependency "ruby-processing",  [">= 2.6.7"]
  s.files       = ["lib/soby.rb", "lib/soby/cam.rb", "lib/soby/slide.rb", "lib/soby/presentation.rb", "lib/soby/slide.rb", "lib/soby/transforms.rb"]
  s.homepage    =
    'https://github.com/poqudrof/Soby'
  s.license       = 'LGPL'
end
