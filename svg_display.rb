
module Soby 


  Priority = Struct.new(:index, :value, :element)

  class SvgDisplay

    def initialize pshape, svg
      @svg = svg
      @pshape = pshape
      @priorities = []

      svg.children.each do |child| 
        if child.name == "g"
          @svg = child
        end
      end

      puts "PSHAPE"
      add_children_pshape(@pshape, 0)

      puts "SVG"
      add_children_svg(@svg, 1)

    end

    def add_children_svg(element, level)
#      puts "Visiting " << element.name << " " << level.to_s

      return if element.children.size <= 0
      
      element_id = element.attributes["id"] 
      if element_id != nil      
        puts "Level " << element_id << " " << level.to_s
      end
      
      element.children.each_with_index do |child, id|
        
        child_id = child.attributes["id"] 
        if child_id != nil      
          puts "Child " << child_id << " " << id.to_s
        end
        # if child.name == "image" 
        #   puts "Image Found ! level : " << level.to_s << " ID " << id.to_s 
        # end

        add_children_svg(child, level + 1)
      end
    end


    def add_children_pshape(element, level)

      return if element.children.size <= 0
      puts "level " << element.name << " " << level.to_s
      
      element.children.each_with_index do |child, id|
        puts "child " << child.name << " " << id.to_s
        add_children_pshape(child, level + 1)
      end
    end
  end
end
