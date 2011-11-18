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
      ms = CrewMembership.new(ship, person)
      ms.save.should be_true
      ms.persisted?.should be_true
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
  
  describe "Retrieve records from the store" do
    
    it "should allow fetching a record by its id" do
      CrewMembership.should respond_to(:find)
    end
    
    it "should instantiate a relationship model" do
      ms = CrewMembership.create(ship, person, { :rank => 'Captain' })
      CrewMembership.find(ms.id).should be_a(CrewMembership)
    end
    
  end
  
  describe "Should populate source and destination after retrieval from storage" do
    
    let(:membership) { CrewMembership.create(ship, person, { :rank => 'Captain' }) }
    
    subject { CrewMembership.find(membership.id) }
    
    it { should respond_to(:source) }
    it { should respond_to(:destination) }
    
    it "should populate the source after retrieval" do
      subject.source.id.should == ship.id
    end
    
    it "should populate the destination after retrieval" do
      subject.destination.id.should == person.id
    end
    
  end
  
end