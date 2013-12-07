module Quandl
module Operation
class Value
  
  class << self
    
    def precision(data, prec=14)
      r = []
      data.each do |row|
        new_row = [row[0]]
        row[1..-1].each do |v|
          new_row << Float("%.#{prec}g" % v)
        end
        r << new_row
      end
      r
    end
    
  end

end
end
end