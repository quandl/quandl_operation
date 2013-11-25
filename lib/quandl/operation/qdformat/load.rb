class Quandl::Operation::QDFormat::Load
  
  SECTION_DELIMITER = '-'
  
  class << self
  
    def from_file(path)
      from_string(File.read(path).strip)
    end
  
    def from_string(input)
      nodes = []
      section_type = :data
      input.each_line do |rline|
        # strip whitespace
        line = rline.strip.rstrip
        # ignore comments and blank lines
        next if line[0] == '#' || line.blank?
        
        # are we looking at an attribute?
        if line =~ attribute_format
          # if we are leaving the data section
          # then this is the start of a new node
          nodes << { attributes: '', data: '' } if section_type == :data
          # update the section to attributes
          section_type = :attributes
          
        # have we reached the end of the attributes?
        elsif line[0] == '-'
          # update the section to data
          section_type = :data
          # skip to the next line
          next
        end
        # add the line to it's section in the current node.
        # YAML must include whitespace
        nodes[-1][section_type] += (section_type == :data) ? "#{line}\n" : rline
      end
      # append the current node
      nodes = parse_nodes(nodes)
      nodes = initialize_nodes(nodes)
      nodes
    end
    
    
    protected
    
    def parse_nodes(nodes)
      nodes.collect do |node|
        # parse attrs as yaml
        node[:attributes] = YAML.load( node[:attributes] )
        # parse data as csv
        node[:attributes][:data] = CSV.parse(node[:data])
        node
      end
    end
    
    def initialize_nodes(nodes)
      nodes.collect do |node|
        Quandl::Operation::QDFormat::Node.new(node[:attributes])
      end
    end
    
    def attribute_format
      /^([a-z0-9_]+): (.+)/
    end
  
  end

end