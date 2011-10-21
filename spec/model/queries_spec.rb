require 'spec_helper'

describe "Node Queries" do
  
  subject { Person }
  
  describe "fetching a node" do
    
    it { should respond_to(:find_by_id) }
    
    it "should find a node based on its id" do
      record = subject.find_by_id(2)
      record.should be_a(Person)
      record.id.should == 2
    end
    
    it "should not instatiate the node if it is of the wrong type" do
      pending
      #record = Person.find_by_id(2)
      #record.should be_nil
    end
    
  end
  
end
