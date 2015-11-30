# subclasses
require 'quandl/operation/collapse/guess'
# collapse
module Quandl
  module Operation
    class Collapse
      class << self
        def perform(data, type)
          assert_valid_arguments!(data, type)
          # nothing to do with an empty array
          return data unless data.compact.present?
          # source order
          order = Sort.order?(data)
          # operations expect data in ascending order
          data = Sort.asc(data)
          # collapse
          data = collapse(data, type)
          # return to original order
          data = Sort.desc(data) if order == :desc
          # onwards
          data
        end

        def assert_valid_arguments!(data, type)
          fail ArgumentError, "data must be an Array. Received: #{data.class}" unless data.is_a?(Array)
          fail ArgumentError, "frequency must be one of #{valid_collapses}. Received: #{type}" unless valid?(type)
        end

        def valid_collapse?(type)
          valid?(type)
        end

        def valid?(type)
          valid_collapses.include?(type.try(:to_sym))
        end

        def valid_collapses
          [:daily, :weekly, :monthly, :quarterly, :annual]
        end

        def collapse(data, frequency)
          return data unless valid_collapse?(frequency)

          # Special scenario where we are only fetching the `date` column
          date_column_only = data.count > 0 && data[0].count == 1

          # store the new collapsed data
          collapsed_data = {}
          range = find_end_of_range(data[0][0], frequency)

          # iterate over the data
          data.each do |row|
            # grab date and values
            date = row[0]
            value = row[1..-1]
            value = value.first if value.count == 1

            # bump to the next range if it exceeds the current one
            range = find_end_of_range(date, frequency) unless inside_range?(date, range)

            # consider the value for the next range
            next unless inside_range?(date, range) && (value.present? || date_column_only)
            value = merge_row_values(value, collapsed_data[range]) unless collapsed_data[range].nil?
            # assign value
            collapsed_data[range] = value
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

        def merge_row_values(top_row, bottom_row)
          # merge previous values when nils are present
          if top_row.is_a?(Array) && top_row.include?(nil)
            # find nil indexes
            indexes = find_each_index(top_row, nil)
            # merge nils with previous values
            indexes.each { |index| top_row[index] = bottom_row[index] }
          end
          top_row
        end

        def collapses_greater_than(freq)
          return [] unless freq.respond_to?(:to_sym)
          index = valid_collapses.index(freq.to_sym)
          index.present? ? valid_collapses.slice(index + 1, valid_collapses.count) : []
        end

        def collapses_greater_than_or_equal_to(freq)
          return [] unless freq.respond_to?(:to_sym)
          valid_collapses.slice(valid_collapses.index(freq.to_sym), valid_collapses.count)
        end

        def frequency?(data)
          Guess.frequency(data)
        end

        def inside_range?(date, range)
          date <= range
        end

        def find_end_of_range(date, frequency)
          date.end_of_frequency(frequency)
        end

        def find_each_index(array, find)
          found = -1
          index = -1
          q = []
          while found
            found = array[index + 1..-1].index(find)
            if found
              index = index + found + 1
              q << index
            end
          end
          q
        end
      end
    end
  end
end
