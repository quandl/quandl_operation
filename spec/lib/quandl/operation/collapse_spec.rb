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
  
end