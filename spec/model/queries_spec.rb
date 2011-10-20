require 'spec_helper'

describe "Node Queries" do
  
  subject { TestNodeWithCastedProperties }
  
  describe "fetching a node" do
    
    it { should respond_to(:find_by_id) }
    
    it "should find a node based on its id" do
      record = subject.find_by_id(2)
      record.should be_a(TestNodeWithCastedProperties)
      record.id.should == 2
    end
    
    it "should not instatiate the node if it is of the wrong type" do
      pending
      #record = LocalizedNodeWithProperties.find_by_id(2)
      #record.should be_nil
    end
    
  end
  
end
