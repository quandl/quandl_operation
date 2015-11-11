# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Collapse do
  subject { Quandl::Operation::Collapse }

  it { should respond_to :perform }

  its(:valid_collapses) { should include :daily }
  its(:valid_collapses) { should include :weekly }
  its(:valid_collapses) { should include :monthly }

  it 'should return collapses_greater_than :weekly' do
    subject.collapses_greater_than(:weekly).should eq [:monthly, :quarterly, :annual]
  end

  it 'should return collapses_greater_than_or_equal_to :weekly' do
    subject.collapses_greater_than_or_equal_to(:weekly).should eq [:weekly, :monthly, :quarterly, :annual]
  end

  it 'should return collapses_greater_than :daily' do
    subject.collapses_greater_than(:daily).should eq [:weekly, :monthly, :quarterly, :annual]
  end

  it 'should return collapses_greater_than_or_equal_to :daily' do
    subject.collapses_greater_than_or_equal_to(:daily).should eq [:daily, :weekly, :monthly, :quarterly, :annual]
  end

  it 'should return collapses_greater_than :annual' do
    subject.collapses_greater_than(:annual).should eq []
  end

  it 'should return collapses_greater_than_or_equal_to :annual' do
    subject.collapses_greater_than_or_equal_to(:annual).should eq [:annual]
  end

  def table_range(from, to, columns = 1)
    days = (to - from).to_i
    r = days.times.collect do |i|
      [from + i] + columns.times.collect { (rand(1000) * 0.7) + i }
    end
    r
  end

  describe '.perform' do
    let(:data) do
      [
        [Date.parse('2013-09-01'), 56.2, nil, nil], [Date.parse('2013-08-13'), 55.7, nil, nil],
        [Date.parse('2013-08-01'), nil, 136_133.0, nil], [Date.parse('2013-07-13'), 55.4, nil, nil],
        [Date.parse('2013-07-01'), nil, 135_964.0, nil], [Date.parse('2013-06-13'), 50.9, nil, nil],
        [Date.parse('2013-06-01'), nil, 135_860.0, nil]
      ]
    end

    it 'should collapse data with nils' do
      subject.perform(data, :monthly).should eq [
        [Date.parse('2013-09-30'), 56.2, nil, nil], [Date.parse('2013-08-31'), 55.7, 136_133.0, nil],
        [Date.parse('2013-07-31'), 55.4, 135_964.0, nil], [Date.parse('2013-06-30'), 50.9, 135_860.0, nil]
      ]
    end

    it 'should handle empty data' do
      subject.perform([], :weekly).should eq []
    end

    it 'should handle empty data' do
      subject.perform([nil], :weekly).should eq [nil]
    end
  end

  describe '.collapse' do
    it 'should handle data sets with one data point only' do
      data = [[Date.parse('2011-11-09'), 42]]
      subject.collapse(data, :daily).should eq [[Date.parse('2011-11-09'), 42]]
      subject.collapse(data, :weekly).should eq [[Date.parse('2011-11-13'), 42]]
      subject.collapse(data, :monthly).should eq [[Date.parse('2011-11-30'), 42]]
      subject.collapse(data, :quarterly).should eq [[Date.parse('2011-12-31'), 42]]
      subject.collapse(data, :annual).should eq [[Date.parse('2011-12-31'), 42]]
    end

    it 'should handle data sets with only two data points, 1 day apart' do
      data = [[Date.parse('2011-11-09'), 20_111_109], [Date.parse('2011-11-10'), 20_111_110]]

      subject.collapse(data, :daily).should eq data
      subject.collapse(data, :weekly).should eq [[Date.parse('2011-11-13'), 20_111_110]]
      subject.collapse(data, :monthly).should eq [[Date.parse('2011-11-30'), 20_111_110]]
      subject.collapse(data, :quarterly).should eq [[Date.parse('2011-12-31'), 20_111_110]]
      subject.collapse(data, :annual).should eq [[Date.parse('2011-12-31'), 20_111_110]]
    end

    it 'should handle data sets one year of daily data' do
      data = table_range Date.parse('Jan 1, 2011'), Date.parse('Dec 31, 2011'), 2
      data.count.should eq 364
      subject.collapse(data, :daily).count.should eq 364
      subject.collapse(data, :weekly).count.should eq 53
      subject.collapse(data, :monthly).count.should eq 12
      subject.collapse(data, :quarterly).count.should eq 4
      subject.collapse(data, :annual).count.should eq 1
    end
  end

  describe '.collapses_greater_than' do
    it 'should return minimum frequency given nil' do
      subject.collapses_greater_than(nil).should eq []
    end
    it 'should return weekly given daily' do
      subject.collapses_greater_than('daily').should eq [:weekly, :monthly, :quarterly, :annual]
    end
    it 'should return [] given annual' do
      subject.collapses_greater_than(:annual).should eq []
    end
  end

  describe '.collapses_greater_than_or_equal_to' do
    it 'should return minimum frequency given nil' do
      subject.collapses_greater_than_or_equal_to(nil).should eq []
    end
    it 'should return weekly given weekly' do
      subject.collapses_greater_than_or_equal_to('weekly').should eq [:weekly, :monthly, :quarterly, :annual]
    end
    it 'should return [] given annual' do
      subject.collapses_greater_than_or_equal_to(:annual).should eq [:annual]
    end
  end
end
