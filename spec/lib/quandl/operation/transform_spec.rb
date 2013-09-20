# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Transform do

  context "rdiff_from" do
    
    it "should transform the data correctly" do
      data = [[1,3,5],[4,5,4],[5,15,20]]
      result = Quandl::Operation::Transform.perform(data, :rdiff_from)
      result.should eq [[1,4,3],[4,2,4],[5,0,0]]
    end
    
  end

end
