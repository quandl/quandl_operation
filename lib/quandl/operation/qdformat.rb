class Quandl::Operation::QDFormat
  
  attr_accessor :source_code, :code, :name, :description, :data, :column_names
  
  class << self
  
    def parse(output)
      datasets = []
      attributes = {}
      # for each line
      output.each_line do |line|
        # strip whitespace
        line = line.strip.rstrip
        
        # skip blank
        if line.blank?
          next
          
        # - denotes new dataset  
        elsif line[0] == '-'
          # append current dataset
          datasets << attributes unless attributes.blank?
          # reset attributes for next dataset
          attributes = {}
        
        # without the data key we're still adding metadata
        elsif !attributes.has_key?(:data)
          # for each rule
          matched = false
          rules.each do |name, rule|
            # test line
            m = line.match(rule)
            # if the rule matches
            if !matched && m.present?
              matched = true
              case name
              when :full_code then attributes[:full_code] = line
              when :attribute then attributes[m[1].to_sym] = m[2]
              end
            end
          end
          # if no match was found for this line it must be data
          attributes[:data] = line if !matched
        # otherwise we're adding data
        else
          attributes[:data] += "\n" + line
        end
      end
      datasets << attributes unless attributes.blank?
      datasets.collect{|attrs| self.new(attrs) }
    end
    
    def rules
      {
        full_code:      /^([A-Z0-9_]+)\/([A-Z0-9_]+)$/,
        attribute:      /^([a-z0-9_]+): (.+)/
      }
    end
  
  end
  
  def initialize(attributes)
    self.full_code = attributes[:full_code]
    self.name = attributes[:name]
    self.description = attributes[:description]
    self.column_names = attributes[:headers]
    self.data = attributes[:data]
  end
  
  def inspect
    "<##{self.class.name}" + 
    [:full_code, :name, :description, :column_names].inject({}){|m,k| m[k] = self.send(k); m }.to_s +
    " >"
  end
  
  def column_names=(names)
    names = names.split(",").collect(&:strip) if names.is_a?(String)
    @column_names = Array(names).flatten
  end
  
  def full_code=(value)
    value = value.split('/')
    self.source_code = value[0]
    self.code = value[1]
  end
  
  def full_code
    [source_code, code].join('/')
  end
  
  def data=(rows)
    @data = rows
  end
  
end