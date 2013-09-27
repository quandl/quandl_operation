# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Parse do
  subject{ Quandl::Operation::Parse }
  let(:csv_data){ "#{Date.today}, 1.0, 2.0" }
  let(:hash_data){ { Date.today.to_s => [ 1.0, 2.0 ] } }
  let(:array_data){ [[ Date.today.to_s, 1.0, 2.0 ]] }
  let(:julian_data){ [[ Date.today.jd, 1.0, 2.0 ]] }
  
  it "#hash outputs array" do
    subject.hash( hash_data ).should eq array_data
  end
  
  it "#csv outputs array" do
    subject.csv( csv_data ).should eq array_data
  end
  
  describe "#perform" do
    it "should handle csv_data" do
      subject.perform( csv_data ).should eq julian_data
    end
    it "should handle julian_data" do
      subject.perform( julian_data ).should eq julian_data
    end
    it "should handle hash_data" do
      subject.perform( hash_data ).should eq julian_data
    end
    it "should handle array_data" do
      subject.perform( array_data ).should eq julian_data
    end
  end
  
end


