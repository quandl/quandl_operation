# encoding: utf-8
require 'spec_helper'

describe Date do
  
  subject { Date.today }
  
  describe "#start_of_frequency" do
    
    context "given valid input" do
      it "should return the beginning of the month" do
        subject.start_of_frequency(:monthly).should eq Date.today.beginning_of_month
      end
    end
    
    context "given invalid input" do
      it "should return the date" do
        subject.start_of_frequency(:hippo).should eq Date.today
      end
    end
    
  end
  
  describe "#end_of_frequency" do
    
    context "given valid input" do
      it "should return the beginning of the month" do
        subject.end_of_frequency(:monthly).should eq Date.today.end_of_month
      end
    end
    
    context "given invalid input" do
      it "should return the date" do
        subject.end_of_frequency(:hippo).should eq Date.today
      end
    end
    
  end
end