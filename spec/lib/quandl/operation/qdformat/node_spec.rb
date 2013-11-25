# encoding: utf-8
require 'quandl/operation/qdformat'
require 'spec_helper'

describe Quandl::Operation::QDFormat::Node do
  
  let(:attributes) { {
    code:           'DATASET_CODE',
    source_code:    'SOURCE_CODE',
    name:           'Test Dataset Name 1',
    description:    "Here is a description with multiple lines.\\n This is the second line.",
    column_names:   ['Date', 'Value', 'High', 'Low'],
    data:           [["2013-11-20", "9.99470588235294", "11.003235294117646", "14.00164705882353"], 
                    ["2013-11-19", "10.039388096885814", nil, "14.09718770934256"]], 
  }}
  
  subject{ Quandl::Operation::QDFormat::Node.new(attributes) }
  
  its(:code){ should eq 'DATASET_CODE' }
  its(:source_code){ should eq 'SOURCE_CODE' }
  its(:name){ should eq 'Test Dataset Name 1' }
  its(:description){ should eq "Here is a description with multiple lines.\\n This is the second line." }
  its(:column_names){ should eq ['Date', 'Value', 'High', 'Low'] }
  its(:data){ should eq [["2013-11-20", "9.99470588235294", "11.003235294117646", "14.00164705882353"], 
                    ["2013-11-19", "10.039388096885814", nil, "14.09718770934256"]] }
                    
  its(:attributes){ should eq attributes }
  
  its(:to_qdf){ should eq %Q{source_code: SOURCE_CODE
code: DATASET_CODE
name: Test Dataset Name 1
description: Here is a description with multiple lines.\\n This is the second line.
Date,Value,High,Low
2013-11-20,9.99470588235294,11.003235294117646,14.00164705882353
2013-11-19,10.039388096885814,,14.09718770934256
}}

end