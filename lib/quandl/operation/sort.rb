module Quandl
  module Operation
    class Sort
      class << self
        def order?(data)
          return :none if data.blank? || data[0].blank? || data[1].blank?
          data[0][0] > data[1][0] ? :desc : :asc
        end

        def order(data, order = :asc)
          # ascending
          case order
          when :asc   then data = sort_asc(data)
          when :desc  then data = sort_desc(data)
          end
          data
        end

        def asc(data)
          data.sort_by { |r| r[0] }
        end

        def desc(data)
          data.sort_by { |r| r[0] }.reverse
        end
      end
    end
  end
end
