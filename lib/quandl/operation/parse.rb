require 'csv'

module Quandl
module Operation
  
class Parse
  
  class << self
  
    def perform(data)
      return [] if data.blank?
      t1 = Time.now
      data = csv(data)
      data = unknown_date_format_to_julian(data)
      data = sort(data)
      Quandl::Logger.debug "#{self.name}.perform (#{t1.elapsed.microseconds}ms)"
      data
    end
  
    def csv(data)
      data = CSV.parse( data ) if data.is_a?(String)
      data = values_to_float(data)
      data
    end
    
    def sort(data, order = :asc)
      data_order = sort_order?(data)
      # ascending
      if order == :asc  && data_order != :asc
        data = sort_asc(data)
        # descending
      elsif order == :desc && data_order != :desc
        data = sort_desc(data)
      end
      data
    end
  
    def sort_order?(data)
      return :none if data.blank? || data[0].blank? || data[1].blank?
      data[0][0] > data[1][0] ? :desc : :asc
    end
  
    def sort_asc(data)
      data.sort_by{|r| r[0] }
    end
  
    def sort_desc(data)
      data.sort_by{|r| r[0] }.reverse
    end
    
    def unknown_date_format_to_julian(data)
      return data if data_missing_rows?(data)
      date = data[0][0]
      # formatted like: "2013-06-18"
      return date_to_julian(data) if date.is_a?(String) && date =~ /[0-9]{4}-[0-9]{2}-[0-9]{2}/
      # formatted like: "2456463"
      return julian_string_to_integer(data)
    end
    
    def date_to_julian(data)
      return data if data_missing_rows?(data) || data[0][0].is_a?(Integer)
      # dont alter by reference
      result = []
      # for each row
      data.each_with_index do |row, index|
        # copy
        nrow = row.dup
        # string to date
        date = nrow[0]
        date = Date.parse(nrow[0]) if nrow[0].is_a?(String)
        # date to julian
        nrow[0] = date.jd if date.respond_to?(:jd)
        # save result
        result[index] = nrow
      end
      # all done
      result
    end
  
    def julian_to_date(data)
      return data if data_missing_rows?(data) || data[0][0].is_a?(Date)
      # dont alter by reference
      result = []
      # for each row
      data.each_with_index do |row, index|
        # copy
        nrow = row.dup
        # parse date
        nrow[0] = Date.jd( nrow[0].to_i ) unless nrow[0].is_a?(Date)
        # save result
        result[index] = nrow
      end
      # all done
      result
    end
  
    def julian_string_to_integer(data)
      # skip when already formatted correctly
      return data if data_missing_rows?(data) || data[0][0].is_a?(Integer) || data[0][0].is_a?(Date)
      # otherwise cast string jds to int
      data.collect{|r| r[0] = r[0].to_i; r  }
    end
    
    def values_to_float(data)
      # skip unless value is a string
      return data if data_missing_rows?(data) || !data[0][1].is_a?(String)
      # cast values to float
      data.collect do |row|
        new_row = [row[0]]
        row[1..-1].each_with_index do |value, index|
          value = value.to_f if value.is_a?(String)
          new_row[index + 1] = value
        end
        new_row
      end
    end
    
    def data_missing_rows?(data)
      !data_has_rows?(data)
    end
    
    def data_has_rows?(data)
      data.is_a?(Array) && data[0].is_a?(Array) && data[0][0].present?
    end
    
  end
  
end
end
end