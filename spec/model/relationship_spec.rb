require "spec_helper"

describe Architect4r::Model::Relationship do
  
  let(:person) { Person.create(:name => 'Niobe', :human => true) }
  let(:ship) { Ship.create(:name => 'Logos', :crew_size => 2) }
  
  describe "initialization of new instances" do
    
    it "should accept zero arguments" do
      lambda { CrewMembership.new }.should_not raise_error(ArgumentError)
    end
    
    it "should accept just a hash of properties" do
      ms = CrewMembership.new( :rank => 'Captain' )
      ms.rank.should == 'Captain'
    end
    
    it "should accept the source and destination node" do
      ms = CrewMembership.new(ship, person)
      ms.source.should == ship
      ms.destination.should == person
    end
    
    it "should accept the source node, destination node, and properties" do
      ms = CrewMembership.new(ship, person, { :rank => 'Captain' })
      ms.source.should == ship
      ms.destination.should == person
      ms.rank.should == 'Captain'
    end
    
    it "should always require a source and destination" do
      fs = CrewMembership.new(:member_since => DateTime.new, :rank => 'Captain')
      fs.valid?.should be_false
    end
    
  end
  
  describe "Creating a new relationship" do
    
    it "should create a new relationship" do
      ms = CrewMembership.new(ship, person, { :rank => 'Captain' })
      ms.save.should be_true
    end
    
    it "should allow changing relationship properties" do
      ms = CrewMembership.new(ship, person, { :rank => 'Captain' })
      ms.save.should be_true
      
      ms.rank = 'Operator'
      ms.save.should be_true
    end
    
    it "should allow deleting relationships" do
      ms = CrewMembership.new(ship, person, { :rank => 'Captain' })
      ms.save.should be_true
      ms.destroy.should be_true
    end
    
  end
  
end