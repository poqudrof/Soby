module Soby

  SLEEP_TIME = 5

  ## used outside
  # def Soby.load_presentation (program_name, svg_name)
  #   puts "Loading program"
  #   load program_name
  #   puts "Loading prez"
  #   (PresentationLoader.new($app, $app.sketchPath(svg_name), program_name)).presentation
  # end

  def Soby.load_presentation(svg_name)
    PresentationLoader.new($app, Dir.pwd + "/" + svg_name).presentation
  end

  def Soby.auto_update soby_player
    puts "Sketch Root" + SKETCH_ROOT
    files = find_files
    svg_name = soby_player.prez.url

    time = Time.now
    soby_player.thread = Thread.new {
      loop do

        if files.find { |file| FileTest.exist?(file) && File.stat(file).mtime > time }
          puts 'reloading sketch...'
          time = Time.now
          presentation = (PresentationLoader.new($app, svg_name)).presentation
          start_presentation presentation
        end

        sleep SLEEP_TIME
        return if $app == nil
      end
    }
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
