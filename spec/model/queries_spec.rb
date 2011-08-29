require 'spec_helper'

describe "Node Queries" do
  
  subject { TestNodeWithCastedProperties }
  
  describe "fetching a node" do
    
    it { should respond_to(:find_by_id) }
    
    it "should find a node based on its id" do
      instrument = subject.find_by_id(13)
      instrument.should be_a(TestNodeWithCastedProperties)
      instrument.id.should == 13
    end
    
  end
  
end