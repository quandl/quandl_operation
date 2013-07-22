module Quandl
module Operation
  
class Transform
  class << self

    def perform( data, type)
      data = Parse.sort( data, :asc )
      data = Parse.values_to_float(data)
      data = transform_and_log( data, type)
      data
    end
    
    def transform_and_log( data, type)
      t1 = Time.now
      r = transform( data, type)
      Quandl::Logger.debug "#{self.name}.perform(#{data.try(:count)} rows, #{type}) (#{t1.elapsed.microseconds}ms)"
      r
    end
    
    def valid_transformation?(type)
      valid_transformations.include?( type.try(:to_sym) )
    end
    
    def valid_transformations
      [ :diff, :rdiff, :cumul, :normalize, :rdiff_from ]
    end
  
    def transform( data, type)
      return data if data.blank?
      #Transforms table from actual data points
      #to differences between points (:diff)
      #or a ratio between points(:rdiff)
      #or a ratio between the latest point and an earlier point (:rdiff_from)
      #If type is other than these two, nothing is done.
    
      # ensure that type is in the expected format
      type = type.try(:to_sym)
      # nothing to do unless valid transform
      return data unless valid_transformation?( type )
    
      temparr = Array.new
      #first make a keylist
      keylist = data.transpose.first
      # now sort the keylist from oldest to newest
      # unless there is only one point
      if keylist.count > 1
        keylist = keylist.reverse if keylist[0] > keylist[1] # better performance if we do this first
        keylist.sort!
      end

      #find number of columns
      numcols = data.first.size - 1
      if type == :normalize
        divisor = Array.new(numcols,nil)
        0.upto(keylist.length - 1) do |i|
          temparr[i] = []
          curr_row = data[i][1..-1]
          0.upto(numcols-1) do |x|
            if curr_row[x].nil?
              temparr[i][x] = nil
            elsif divisor[x].nil?
              if curr_row[x].to_f != 0 
                divisor[x] = curr_row[x].to_f
                temparr[i][x] = 100.0
              else
                temparr[i][x] = 0
              end
            else
              temparr[i][x] = curr_row[x] / divisor[x] * 100.0
            end
          end
        end
        0.upto(keylist.length-1) do |i|
          data[i] = [keylist[i], temparr[i]].flatten
        end
      elsif [:diff, :rdiff].include? type
        #now build temparr
        1.upto(keylist.length - 1) do |i|
          temparr[i] = []
          curr_row = data[i][1..-1]
          prev_row = data[i-1][1..-1]
          0.upto(numcols-1) do |x| 
            if type == :diff
              if !curr_row[x].nil? and !prev_row[x].nil?
                temparr[i][x] = Float(curr_row[x]) - Float(prev_row[x])
              else
                temparr[i][x] = nil
              end
            else
              if !curr_row[x].nil? and !prev_row[x].nil? and prev_row[x] != 0
                temparr[i][x] = ( Float(curr_row[x]) - Float(prev_row[x]) ) / Float( prev_row[x] )
              else
                temparr[i][x] = nil
              end
            end
          end
        end

        #now put temparr into datapac
        1.upto(keylist.length-1) do |i|
          data[i] = [keylist[i], temparr[i]].flatten
        end

        #delete the first date in datapac (because there is no diff for that)
        data.delete_at(0)
      elsif type == :rdiff_from
        num_rows = keylist.length - 1 
        initial = Array.new(numcols,nil)
        num_rows.downto(1) do |i|
          temparr[i] = []
          curr_row = data[i][1..-1]
          0.upto(numcols-1) do |x|
            if curr_row[x].nil?
              temparr[i][x] = nil
            elsif initial[x].nil?
              initial[x] = curr_row[i][x]
              temparr[i][x] = 0.0
            elsif curr_row[x] == 0
              temparr[i][x] = nil
            else
              temparr[i][x] = ( Float(initial[x]) - Float(curr_row[x]) ) / Float(curr_row[x]) 
          end
        end


        1.upto(keylist.length-1) do |i|
          data[i] = [keylist[i], temparr[i]].flatten
        end
      else
        data = Parse.sort( data, :desc )
        cumulsum = Array.new(numcols,0)
        sumstarted = Array.new(numcols,false)
        #now build temparr
        0.upto(keylist.length - 1) do |i|
          temparr[i] = []
          curr_row = data[i][1..-1]
          0.upto(numcols-1) do |x|
            if !curr_row[x].nil?
              cumulsum[x] = cumulsum[x] + curr_row[x]
              sumstarted[x] = true
            end
            temparr[i][x] = cumulsum[x] if sumstarted[x]
          end
        end
        0.upto(keylist.length-1) do |i|
          data[i] = [keylist[i],temparr[i]].flatten
        end
      end
      data
    end
    
  end
end
end
end