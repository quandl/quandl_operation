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
  
end