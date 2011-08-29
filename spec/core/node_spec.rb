require 'spec_helper'

describe Architect4r::Node do
  
  subject { Architect4r::Node }
  
  it { should respond_to(:new) }
  it { should respond_to(:create) }
  it { should respond_to(:find_by_id) }
  
  describe :root do
    
    it "should always find the root node" do
      subject.root.should be_a(Architect4r::Node)
    end
    
    it "should have the default id equal 0" do
      subject.root.id.should eql(0)
    end
    
  end
  
  describe :find_by_id do
    
    it "should return nil if there was no record" do
      subject.find_by_id(123456789).should be_nil
    end
    
    it "should return a node object for existing records" do
      subject.find_by_id(1).should be_a(Architect4r::Node)
    end
    
  end
  
end