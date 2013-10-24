# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Collapse do
  
  subject { Quandl::Operation::Collapse }
  
  it { should respond_to :perform }
  
  its(:valid_collapses){ should include :daily }
  its(:valid_collapses){ should include :weekly }
  its(:valid_collapses){ should include :monthly }

  it "should return collapses_greater_than :weekly" do
    subject.collapses_greater_than(:weekly).should eq [:monthly, :quarterly, :annual]
  end
  
  it "should return collapses_greater_than_or_equal_to :weekly" do
    subject.collapses_greater_than_or_equal_to(:weekly).should eq [:weekly, :monthly, :quarterly, :annual]
  end

  it "should return collapses_greater_than :daily" do
    subject.collapses_greater_than(:daily).should eq [:weekly, :monthly, :quarterly, :annual]
  end
  
  it "should return collapses_greater_than_or_equal_to :daily" do
    subject.collapses_greater_than_or_equal_to(:daily).should eq [:daily, :weekly, :monthly, :quarterly, :annual]
  end

  it "should return collapses_greater_than :annual" do
    subject.collapses_greater_than(:annual).should eq []
  end
  
  it "should return collapses_greater_than_or_equal_to :annual" do
    subject.collapses_greater_than_or_equal_to(:annual).should eq [:annual]
  end
  
  def table_range(from, to, columns = 1)
    days = to - from
    r = days.times.collect do |i|
      [ from + i ] + columns.times.collect{(rand(1000) * 0.7) + i}
    end
    r
  end
  
  describe "#perform" do
  
    let(:data){
      [[2456537, 56.2, nil, nil], 
       [2456518, 55.7, nil, nil], [2456506, nil, 136133.0, nil], 
       [2456487, 55.4, nil, nil], [2456475, nil, 135964.0, nil], 
       [2456457, 50.9, nil, nil], [2456445, nil, 135860.0, nil]]
    }
    
    it "should collapse data with nils" do
      subject.perform(data, :monthly).should eq [
        [2456566, 56.2, nil, nil], 
        [2456536, 55.7, 136133.0, nil], 
        [2456505, 55.4, 135964.0, nil], 
        [2456474, 50.9, 135860.0, nil]]
    end
   
  end
  
  describe "#collapse" do
  
    it 'should handle data sets with one data point only' do
    
      data = [[ 2455875, 42 ]]
      subject.collapse( data, :daily).should eq [[2455875, 42]]
      subject.collapse( data, :weekly).should eq [[2455879, 42]]
      subject.collapse( data, :monthly).should eq [[2455896, 42]]
      subject.collapse( data, :quarterly).should eq [[2455927, 42]]
      subject.collapse( data, :annual).should eq [[2455927, 42]]
    
    end
  
    it 'should handle data sets with only two data points, 1 day apart' do
    
      data = [[ Date.parse('2011-11-09').jd, 20111109 ],[ Date.parse('2011-11-10').jd, 20111110 ]]
    
      subject.collapse(data, :daily).should eq data
      subject.collapse(data, :weekly).should eq [[ 2455879, 20111110 ]]
      subject.collapse(data, :monthly).should eq [[ 2455896, 20111110 ]]
      subject.collapse(data, :quarterly).should eq [[ 2455927, 20111110 ]]
      subject.collapse(data, :annual).should eq [[ 2455927, 20111110 ]]
    
    end
  
    it 'should handle data sets one year of daily data' do
      data = table_range Date.parse('Jan 1, 2011').jd, Date.parse('Dec 31, 2011').jd, 2
      data.count.should eq 364
      subject.collapse( data, :daily ).count.should eq 364
      subject.collapse( data, :weekly ).count.should eq 53
      subject.collapse( data, :monthly ).count.should eq 12
      subject.collapse( data, :quarterly ).count.should eq 4
      subject.collapse( data, :annual ).count.should eq 1
    end
   
  end
  
end