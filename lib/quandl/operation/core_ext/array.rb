class Array
  def self.forwardable_methods
    [:reject, :keep_if, :permutation, :to_a, :cycle, :drop, :take_while, :map, :rotate, :each_slice, :pack, :select!, :combination, :repeated_combination, :shift, :select, :reverse!, :==, :clear, :rotate!, :inspect, :iter_for_each, :sort_by!, :compact!, :|, :copy_data_simple, :nitems, :zip, :take, :rassoc, :flatten!, :join, :compact, :[]=, :frozen?, :slice!, :drop_while, :reverse_each, :shuffle, :slice, :reverse, :insert, :uniq, :first, :count, :fetch, :hash, :to_ary, :find_index, :replace, :-, :product, :iter_for_reverse_each, :pop, :push, :sort, :fill, :uniq!, :length, :&, :flatten, :repeated_permutation, :[], :shuffle!, :sort!, :sample, :include?, :<<, :dimensions, :collect, :+, :rindex, :<=>, :eql?, :indices, :collect!, :iter_for_each_index, :iter_for_each_with_index, :index, :*, :indexes, :copy_data, :delete, :to_s, :assoc, :delete_at, :unshift, :delete_if, :empty?, :reject!, :last, :size, :concat, :map!, :at, :each_index, :transpose, :values_at, :each, :enum_cons, :group_by, :enum_with_index, :entries, :with_object, :chunk, :each_with_index, :min, :inject, :one?, :partition, :enum_slice, :none?, :max_by, :any?, :flat_map, :reduce, :each_entry, :find, :minmax_by, :collect_concat, :each_cons, :member?, :max, :sort_by, :detect, :all?, :minmax, :grep, :each_with_object, :find_all]
  end
  def average
    self.sum / self.count
  end
  def extract_options
    last.is_a?(::Hash) ? last : {}
  end
end