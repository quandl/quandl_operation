# encoding: utf-8
require 'spec_helper'

describe Quandl::Operation::Collapse do
  
  subject { Quandl::Operation::Collapse }
  
  it { should respond_to :perform }
  
  its(:valid_collapses){ should include :daily }
  its(:valid_collapses){ should include :weekly }
  its(:valid_collapses){ should include :monthly }

end