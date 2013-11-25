class Quandl::Operation::QDFormat::Node
  
  ATTRIBUTES = :source_code, :code, :name, :description, :column_names, :data
  attr_accessor *ATTRIBUTES

  def initialize(attrs)
    assign_attributes(attrs)
  end

  def assign_attributes(attrs)
    attrs.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end

  def attributes
    ATTRIBUTES.inject({}){|m,k| m[k] = self.send(k); m }
  end

  def inspect
    "<##{self.class.name} #{attributes.to_s} >"
  end

  def full_code=(value)
    value = value.split('/')
    self.source_code = value[0]
    self.code = value[1]
  end

  def full_code
    [source_code, code].join('/')
  end
  
  def description=(value)
    @description = value.to_s.gsub('\n', "\n")
  end
  
  def data=(rows)
    self.column_names = rows.shift unless rows.first.collect{|r| r.to_s.numeric? }.include?(true)
    @data = rows
  end

  def column_names=(names)
    @column_names = Array(names).flatten.collect{|n| n.strip.rstrip }
  end

  def to_qdf
    Quandl::Operation::QDFormat::Dump.node(self)
  end
  
end