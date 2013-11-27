class Quandl::Operation::Parse
  
  class << self
  
    def perform(data)
      return [] if data.blank?
      data = hash_to_array(data)
      data = csv_to_array(data)
      # data = to_jd(data)
      data = to_date(data)
      data.dup
    end
    
    def hash_to_array(data)
      data = data.collect{|k,v| [k] + v } if data.kind_of?(Hash)
      data
    end
  
    def csv_to_array(data)
      if data.is_a?(String)
        data = data.gsub('\n', "\n")
        data = CSV.parse( data )
      end
      data = values_to_float(data)
      data
    end
    
    def sort(data, order = :asc)
      # ascending
      case order
      when :asc   then data = sort_asc(data)
      when :desc  then data = sort_desc(data)
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
    
    def to_date(data)
      return data if data_missing_rows?(data)
      # guess the current date format
      format = date_format?(data)
      # convert dates to Date
      case format
      when :date            then return data
      when :date_string     then return date_strings_to_date( data )
      when :jd, :jd_string  then return jds_to_date( data )
      when :unknown         then raise_date_format_error!( data[0] )
      end
      # return data
      data
    end
    
    def to_jd(data)
      return data if data_missing_rows?(data)
      # guess the current date format
      format = date_format?(data)
      # convert dates to Date
      case format
      when :jd          then return data
      when :jd_string   then return jd_strings_to_jd( data )
      when :date        then return dates_to_jd( data )
      when :date_string then return date_strings_to_jd( data )
      when :unknown     then raise_date_format_error!( data[0] )
      end
      # return data
      data
    end
    
    def date_format?(data)
      value = data[0][0]
      # julian date?
      return :date          if value.is_a?(Date)
      return :jd            if value.is_a?(Integer)
      return :date_string   if value.is_a?(String) && value =~ /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/
      return :jd_string     if value.kind_of?(String) && value.numeric?
      return :unknown
    end
    
    def dates_to_jd(data)
      return data if data_missing_rows?(data) || data[0][0].is_a?(Integer)
      # dont alter by reference
      result = []
      # for each row
      data.each_with_index do |row, index|
        # copy
        row = row.dup
        # string to date
        date = row[0]
        date = Date.parse(row[0]) if row[0].is_a?(String)
        # date to julian
        row[0] = date.jd if date.respond_to?(:jd)
        # save result
        result[index] = row
      end
      # all done
      result
    end
    
    
    ###################
    # DATES TO JULIAN #
    ###################

    def jd_strings_to_jd(data)
      # skip when already formatted correctly
      return data if data_missing_rows?(data) || data[0][0].is_a?(Integer)
      # otherwise cast string jds to int
      output = []
      data.each_with_index do |row, index|
        output << parse_jd_string(row) rescue raise_date_format_error!( row, index, :jd_string )
      end
      output
    end
    
    def date_strings_to_jd(data)
      # skip when already formatted correctly
      return data if data_missing_rows?(data) || data[0][0].is_a?(Date)
      # otherwise cast string jds to int
      output = []
      data.each_with_index do |row, index|
        output << parse_date_string(row).jd rescue raise_date_format_error!( row, index, :date_string )
      end
      output
    end

    
    #################
    # DATES TO DATE #
    #################

    def jds_to_date(data)
      return data if data_missing_rows?(data) || data[0][0].is_a?(Date)
      output = []
      data.each_with_index do |row, index|
        output << parse_jd(row) rescue raise_date_format_error!( row, index, :jd )
      end
      output
    end
  
    def date_strings_to_date(data)
      # skip when already formatted correctly
      return data if data_missing_rows?(data) || data[0][0].is_a?(Date)
      # otherwise cast string jds to int
      output = []
      data.each_with_index do |row, index|
        output << parse_date_string(row) rescue raise_date_format_error!( row, index, :date_string )
      end
      output
    end
    
    
    ###################
    # VALUES TO FLOAT #
    ###################

    def values_to_float(data)
      # skip unless value is a string
      return data if data_missing_rows?(data) || data[0][1].is_a?(Float)
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
    
    
    protected
    
    def parse_jd(row)
      # copy
      row = row.dup
      # ensure date is valid
      raise if row[0] == 0
      # parse
      row[0] = Date.jd( row[0] )
      # save result
      row
    end
    
    def parse_jd_string(row)
      row = row.dup
      row[0] = row[0].to_i
      raise if row[0] == 0
      row
    end
    
    def parse_date_string(row)
      row = row.dup
      # extract date
      date = row[0]
      # split date into parts
      date_values = date.split('-').collect(&:to_i)
      # ensure date is valid
      raise unless date_values.count == 3
      # add to row
      row[0] = Date.new( *date_values )
      row
    end
    
    
    private
    
    def raise_date_format_error!(row, index = 0, type = :date)
      message = "UnknownDateFormat for date: '#{row[0]}' encountered while parsing data at: data[#{index}][0] #{row}"
      raise Quandl::Operation::Errors::UnknownDateFormat, message
    end
    
  end
  
end