# subclasses
require 'quandl/operation/collapse/guess'
# collapse
module Quandl
module Operation

class Collapse

  class << self
  
    def perform(data, frequency)
      data = Parse.sort( data )
      data = collapse_and_log(data, frequency)
      data
    end
    
    def collapse_and_log(*args)
      t1 = Time.now
      r = collapse(*args)
      Quandl::Logger.debug "#{self.name}.perform (#{t1.elapsed.microseconds}ms)"
      r
    end
  
    def collapse(data, frequency)
      # store the new collapsed data
      collapsed_data = {}
      range = find_end_of_range( data[0][0], frequency )
      # iterate over the data
      data.each do |row|
        # grab date and value
        date, value = row[0], row[1..-1]
        value = value.first if value.count == 1
        # bump to the next range if it exceeds the current one
        range = find_end_of_range(date, frequency) unless inside_range?(date, range)
        # consider the value for the next range
        collapsed_data[range] = value if inside_range?(date, range) && value.present?
      end
      to_table(collapsed_data)
    end
    
    def to_table(data)
      data.collect do |date, values|
        if values.is_a?(Array)
          values.unshift(date)
        else
          [date, values]
        end
      end
    end
    
    def frequency?(data)
      Guess.frequency(data)
    end
  
    def inside_range?(date, range)
      date <= range
    end
  
    def find_end_of_range(date, frequency)
      Date.jd(date).end_of_frequency(frequency).jd
    end
  
  end

end
end
end