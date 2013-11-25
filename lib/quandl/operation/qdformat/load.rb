class Quandl::Operation::QDFormat::Load
  
  class << self
  
    def from_file(path)
      from_string(File.read(path).strip)
    end
  
    def from_string(input)
      nodes = []
      input.each_line do |line|
        # strip whitespace
        line = line.strip.rstrip
        # ignore comments and blank lines
        next if line[0] == '#' || line.blank?
        # code_format denotes the start of a new node
        nodes << { attributes: '', data: '' } if line =~ code_format
        # attribute_format denotes an attribute
        if line =~ attribute_format
          # add the attribute to attributes
          nodes[-1][:attributes] += "#{line}\n"
          # otherwise it must be data
        else
          nodes[-1][:data] += "#{line}\n"
        end
      end
      # append the current node
      nodes = parse_nodes(nodes)
      nodes
    end
    
    
    protected
    
    def parse_nodes(nodes)
      nodes.collect do |node|
        node[:attributes] = YAML.load( node[:attributes] )
        node[:attributes][:data] = CSV.parse(node[:data])
        Quandl::Operation::QDFormat::Node.new(node[:attributes])
      end
    end
  
    def code_format
      /^code: (.+)/
    end
  
    def attribute_format
      /^([a-z0-9_]+): (.+)/
    end
  
  end

end