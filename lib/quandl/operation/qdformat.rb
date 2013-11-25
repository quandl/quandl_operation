require 'csv'
require 'yaml'

require 'quandl/operation/qdformat/dump'
require 'quandl/operation/qdformat/load'
require 'quandl/operation/qdformat/node'

class Quandl::Operation::QDFormat
  class << self
    
    def load(input)
      Quandl::Operation::QDFormat::Load.from_string(input)
    end
    
    def load_file(file_path)
      Quandl::Operation::QDFormat::Load.from_file(input)
    end
    
    def dump(nodes)
      Quandl::Operation::QDFormat::Dump.nodes(nodes)
    end
    
  end
end