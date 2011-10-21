require 'spec_helper'

describe "Node Queries" do
  
  subject { Person }
  
  describe "fetching a node" do
    
    it { should respond_to(:find_by_id) }
    
    it "should find a node based on its id" do
      person = Person.create(:name => 'Agent Smith', :human => false)
      person.persisted?.should be_true
      
      record = Person.find_by_id(person.id)
      record.should be_a(Person)
      record.id.should == person.id
    end
    
    it "should not instatiate the node if it is of the wrong type" do
      ship = Ship.create(:name => 'Brahama', :crew_size => 1)
      Person.find_by_id(ship.id).should be_nil
    end
    
  end
  
end
