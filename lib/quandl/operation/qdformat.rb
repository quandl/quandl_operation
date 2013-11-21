class Quandl::Operation::QDFormat
  
  attr_accessor :source_code, :code, :name, :description, :data, :headers
  
  class << self
    
    def read(path)
      parse(File.read(path).strip)
    end
  
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
  
  def initialize(attrs)
    assign_attributes(attrs)
  end
  
  def assign_attributes(attrs)
    attrs.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end
  
  def attributes
    { name: name, source_code: source_code, code: code, description: description, column_names: headers, data: data }
  end
  
  def inspect
    "<##{self.class.name}" + 
    [:full_code, :name, :description, :headers].inject({}){|m,k| m[k] = self.send(k); m }.to_s +
    " >"
  end
  
  def headers=(names)
    names = names.split(",").collect(&:strip) if names.is_a?(String)
    @headers = Array(names).flatten
  end
  def headers_as_qdf
    headers.join(', ') if headers.is_a?(Array)
  end
  
  def full_code=(value)
    value = value.split('/')
    self.source_code = value[0]
    self.code = value[1]
  end
  
  def full_code
    [source_code, code].join('/')
  end
  
  def data_as_qdf
    o = data
    o = o.to_a if o.respond_to?(:to_a)
    o = o.collect(&:to_csv).join if o.respond_to?(:to_csv) && o.first.is_a?(Array)
    o = o.to_csv if o.respond_to?(:to_csv)
    o
  end
  
  def data=(rows)
    @data = rows
  end
  
  def to_qdf
    output = [full_code]
    [:name, :description].each do |attr_name|
      output << "#{attr_name}: #{self.send(attr_name)}" if self.send(attr_name).present?
    end
    output << "headers: #{headers_as_qdf}" if headers_as_qdf.present?
    output << data_as_qdf
    output.join("\n")
  end
  
end