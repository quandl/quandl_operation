# encoding: utf-8
require 'quandl/operation/qdformat'
require 'spec_helper'

describe Quandl::Operation::QDFormat do
  
  let(:qdf_dataset){
    %Q{
      # YAML metadata
      code:           DATASET_CODE
      source_code:    SOURCE_CODE
      name:           Test Dataset Name #{Time.now}
      description:    "Here is a description with multiple lines.\n This is the second line."
      # CSV data
      Date, Value, High, Low
      2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353
      2013-11-19,10.039388096885814,,14.09718770934256
    }
  }
  
  let(:collection){ Quandl::Operation::QDFormat.parse(qdf_dataset) }
  
  describe ".parse" do
    
    subject{ collection }
      
    its(:count){ should eq 2 }
    
    describe "#first" do
      subject{ collection.first }

      it{ should be_a Quandl::Operation::QDFormat }
      its(:source_code){ should eq 'SOURCE_CODE' }
      its(:code){ should eq 'DATASET_CODE' }
      its(:name){ should eq 'Test dataset name' }
      its(:description){ should eq 'Dataset description' }
      its(:headers){ should eq ['Date', 'value', 'high', 'low'] }
      its(:data){ should eq data }
    end
  end
  
  describe "#to_qdf" do
    subject{ collection.first }
    its(:to_qdf){ should eq [full_code, name, description, headers, data].join("\n")}
    
    context "data Array" do
      let(:data){ [['2013-11-20',9.94,11.2],['2013-11-19',9.94,11.2],['2013-11-18',9.94,11.2]] }
      subject{ Quandl::Operation::QDFormat.new( full_code: "TEST/OIL", data: data ) }
      
      its(:to_qdf){ should eq ["TEST/OIL", data.collect(&:to_csv).join].join("\n") }
      
    end
  end
  
end