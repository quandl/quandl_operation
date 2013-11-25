module Quandl
module Operation
class QDFormat

class Dump

  class << self

    def nodes(*args)
      Array(args).flatten.collect{|r| node(r) }.join("\n")
    end

    def node(node)
      self.new(node).to_qdf
    end

  end

  attr_accessor :node

  def initialize(r)
    self.node = r
  end

  def to_qdf
    [attributes, column_names, data].compact.join
  end

  def attributes
    [:source_code, :code, :name, :description].
    inject({}){|m,k| m[k.to_s] = node.send(k) unless node.send(k).blank?; m }.
    to_yaml[4..-1]
  end

  def data
    data = node.data.is_a?(Array) ? node.data.collect(&:to_csv).join : node.data
    data = data.to_csv if data.respond_to?(:to_csv)
    data
  end

  def column_names
    node.column_names.to_csv if node.column_names.present?
  end

end

end
end
end