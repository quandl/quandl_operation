# encoding: utf-8
require 'quandl/operation/qdformat'
require 'spec_helper'

describe Quandl::Operation::QDFormat do
  
  let(:full_code){ "SOURCE_CODE/DATASET_CODE" }
  let(:name){ 'name: Test dataset name' }
  let(:description){ 'description: Dataset description' }
  let(:headers){ 'headers: Date, value, high, low' }
  let(:data){ "2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353\n2013-11-19,10.039388096885814,,14.09718770934256\n2013-11-18,10.03702588792184,11.040801329322205,14.148600982164867\n2013-11-16,10.019903902583621,10.99988541851354,14.186053161235304\n2013-11-15,9.98453953586862,10.922239168500502,\n2013-11-14,10.004508614940358,10.894612328250766,\n2013-11-13,,10.877309120435308,14.187437960548612\n2013-11-12,,10.838918617657301,14.22499294338536\n2013-11-11,9.965116185761039,10.827442115591547,14.178970907392053\n2013-11-09,9.881291973139637,10.924889094631869" }
  
  let(:output){
    %Q{
      ---
      #{full_code}
      #{name}
      #{description}
      #{headers}
      #{data}
      -
      - I am a comment.
      -
      #{full_code}
      #{name}
      #{description}
      #{headers}
      #{data}
      -----
    }
  }
  
  describe ".parse" do
    let(:collection){ Quandl::Operation::QDFormat.parse(output) }
    
    subject{ collection }
      
    its(:count){ should eq 2 }
    
    describe "#first" do
      subject{ collection.first }

      it{ should be_a Quandl::Operation::QDFormat }
      its(:source_code){ should eq 'SOURCE_CODE' }
      its(:code){ should eq 'DATASET_CODE' }
      its(:name){ should eq 'Test dataset name' }
      its(:description){ should eq 'Dataset description' }
      its(:column_names){ should eq ['Date', 'value', 'high', 'low'] }
      its(:data){ should eq data }
    end
  end
  
end