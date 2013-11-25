# encoding: utf-8
require 'quandl/operation/qdformat'
require 'spec_helper'

describe Quandl::Operation::QDFormat do
  
  let(:qdf_dataset){
    %Q{
      # YAML metadata
      code:           DATASET_CODE
      source_code:    SOURCE_CODE
      name:           Test Dataset Name 1
      description:    Here is a description with multiple lines.\\n This is the second line.
      # CSV data
      Date, Value, High, Low
      2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353
      2013-11-19,10.039388096885814,,14.09718770934256
      
      # Second dataset
      code:           DATASET_CODE_2
      source_code:    SOURCE_CODE_2
      name:           Test Dataset Name 2
      description:    Here is a description with multiple lines.
      # CSV data
      Date, Value, High, Low
      2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353
      2013-11-19,10.039388096885814,,14.09718770934256
      2013-11-18,11.039388096885814,,15.09718770934256
    }
  }
  
  let(:collection){ Quandl::Operation::QDFormat.load(qdf_dataset) }
  
  describe ".load" do
    
    subject{ collection }
    
    its(:count){ should eq 2 }
    
    describe "#first" do
      subject{ collection.first }

      it{ should be_a Quandl::Operation::QDFormat::Node }
      its(:source_code){ should eq 'SOURCE_CODE' }
      its(:code){ should eq 'DATASET_CODE' }
      its(:name){ should eq 'Test Dataset Name 1' }
      its(:description){ should eq 'Here is a description with multiple lines.\n This is the second line.' }
      its(:column_names){ should eq ['Date', 'Value', 'High', 'Low'] }
      its(:data){ should eq [
        ["2013-11-20", "9.99470588235294", "11.003235294117646", "14.00164705882353"], 
        ["2013-11-19", "10.039388096885814", nil, "14.09718770934256"]] }
    end
  end
  
  describe "#to_qdf" do
    subject{ collection.first }
    
    its(:to_qdf){ should eq %Q{source_code: SOURCE_CODE
code: DATASET_CODE
name: Test Dataset Name 1
description: Here is a description with multiple lines.\\n This is the second line.
Date,Value,High,Low
2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353
2013-11-19,10.039388096885814,,14.09718770934256
}}
    
    context "data Array" do
      let(:data){ [['2013-11-20',9.94,11.2],['2013-11-19',9.94,11.2],['2013-11-18',9.94,11.2]] }
      subject{ Quandl::Operation::QDFormat::Node.new( full_code: "TEST/OIL", data: data ) }
      
      its(:to_qdf){ should eq "source_code: TEST\ncode: OIL\n2013-11-20,9.94,11.2\n2013-11-19,9.94,11.2\n2013-11-18,9.94,11.2\n" }
      
    end
  end
  
end