
module Soby 


  Priority = Struct.new(:index, :value, :element)

  class SvgDisplay

    def initialize pshape, svg
      @svg = svg
      @pshape = pshape
      @priorities = []

      puts "PSHAPE"
      add_children_pshape(pshape, 0)

      puts "SVG"
      add_children_svg(svg, 0)

    end

    def add_children_svg(element, level)
      puts "Visiting " << element.name << " " << level.to_s

      return if element.children == nil

      element.children.each_with_index do |child, id|
        
        if child.name == "image" 
          puts "Image Found ! level : " << level.to_s << " ID " << id.to_s 
        end

        add_children_svg(child, level + 1)
      end
    end


    def add_children_pshape(element, level)

      puts "Visiting " << element.name << " " << level.to_s

      return if element.children == nil

      element.children.each_with_index do |child, id|
        add_children_pshape(child, level + 1)
      end
    end
  end
end
