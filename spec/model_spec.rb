# encoding: utf-8
require 'spec_helper'

describe ScopeBuilder::Model do
  subject do
    class TestClass
      include ScopeBuilder::Model
      
      scope_builder_for :search
      
      search_scope :limit
      search_scope :offset, prefix: true
      search_helper :tester, ->(t){ t.to_i }
      
    end
    TestClass
  end
  
  it { should respond_to :scope_builder_for }
  it { should respond_to :search_scope }
  it { should respond_to :search_helper }
  it { should respond_to :limit }
  it { should respond_to :offset_search }
  it { should_not respond_to :tester }

end