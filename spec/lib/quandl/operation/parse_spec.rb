# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Parse do
  subject{ Quandl::Operation::Parse }
  let(:escaped_csv){ '2444628,0.00385,0.001,0.123,0.00631,\n2444627,0.00384,0.00159507,0.0056,0.00628948,0.009896' }
  let(:data_array){ [[ 2444628,0.00385,0.001,0.123,0.00631], [ 2444627,0.00384,0.00159507,0.0056,0.00628948,0.009896 ]] }
  
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
    it "handles escaped csv_data" do
      subject.perform( escaped_csv ).should eq data_array
    end
  end
  
end


