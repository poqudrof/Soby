
module Soby

  SLEEP_TIME = 1

  ## used outside
  
  def Soby.load_presentation (program_name, svg_name)
    puts "Loading program"
    load program_name
    puts "Loading prez"
    Presentation.new($app, $app.sketchPath(svg_name), program_name)
  end

  def Soby.auto_update (presentation, file_not_updated)
    
    if $app != nil 
      
      files = find_files_except file_not_updated
      start_presentation presentation

      program_name = presentation.program
      svg_name = presentation.url
      
      time = Time.now 
      
      t = Thread.new {
        loop do

          if files.find { |file| FileTest.exist?(file) && File.stat(file).mtime > time }
            puts 'reloading sketch...'
            
            time = Time.now

            load program_name
            presentation = Presentation.new($app, $app.sketchPath(svg_name), program_name)
            start_presentation presentation
          end

          sleep SLEEP_TIME
          return if $app == nil
        end
      }
    end
  end
  

 ## local use
  
  def Soby.reload_presentation (presentation)
#    load presentation.program
#    presentation.reset
    presentation =  Soby::load_presentation(presentation.program, presentation.url)
  end

  def Soby.start_presentation (presentation)
    $app.set_prez presentation  
  end

  def Soby.find_files_except (name)
    find_files.select { |file_name| not file_name.end_with? name }
  end

  def Soby.find_files
    Dir.glob(File.join(SKETCH_ROOT, "**/*.{svg,glsl,rb}"))
  end
  

  
end
