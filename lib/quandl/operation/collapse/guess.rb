module Quandl
module Operation
class Collapse

class Guess
  class << self
  
    def frequency(data)
      return :annual unless data && data[0] && data[0][0]
      t1 = Time.now
      # find the smallest point of difference between dates
      gap = find_average_gap(data)
      # ensure gap is not negative
      gap = ensure_positive_gap(gap)
      # determine the freq from the size of the smallest gap
      freq = frequency_from_gap(gap)
      Quandl::Logger.debug "#{self.name}.perform (#{t1.elapsed.microseconds}ms)"
      freq
    end
  
    def find_smallest_gap(data)
      # init
      gap = 100_000
      pdate = nil
      # find the smallest gap
      data.each do |row|
        # if the gap is 1, we're done
        break if gap <= 1
        # this row's date
        date = row[0]
        # only if pdate is present
        if pdate
          # calculate the gap
          diff = (pdate - date).to_i
          # replace the previous gap if it is smaller
          gap = diff if diff < gap
        end
        # previous row's date
        pdate = date
      end
      gap
    end
  
    def find_average_gap(data)
      # init
      gap = 100_000
      pdate = nil
      row_count = data.count
      majority_count = (row_count * 0.55).to_i
      gaps = {}
      # find the smallest gap
      data.each do |row|
        # this row's date
        date = row[0]
        # only if pdate is present
        if pdate
          # calculate the gap
          diff = (pdate - date).to_i
          # increment the gap counter
          gaps[diff] ||= 0
          gaps[diff] += 1
          # if the diff count is greater than majority_count, we have a consensus
          return diff if gaps[diff] > majority_count
        end
        # previous row's date
        pdate = date
      end
      gaps.to_a.sort_by{|r| r[1] }.try(:last).try(:first)
    end

    def frequency_from_gap(gap)
    
      case 
      when gap <= 1 then :daily
      when gap <= 10 then :weekly
      when gap <= 31 then :monthly
      when gap <= 93 then :quarterly
      else :annual
      end
    end
  
    def ensure_positive_gap(gap)
      gap = gap.to_i
      gap = gap * -1 if gap < 0
      gap
    end
  
  end
  
end
end
end
end