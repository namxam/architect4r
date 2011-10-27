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
    
    it "should return nil when the node is not found" do
      Person.find_by_id(-1).should be_nil
    end
    
    it "should raise an exception when banged finder is used an no record found" do
      lambda { Person.find_by_id!(-1) }.should raise_error(Architect4r::RecordNotFound)
    end
    
    it "should not raise an exception when banged finder is used an a record is found" do
      person = Person.create(:name => 'The Architect', :human => false)
      lambda { Person.find_by_id!(person.id) }.should_not raise_error(Architect4r::RecordNotFound)
    end
    
  end
  
  describe "counting records" do
    
    it "should count the number of records" do
      Person.create(:name => 'Neo', :human => true)
      Person.create(:name => 'Trinity', :human => true)
      Person.count.should >= 2
    end
    
  end
  
  describe "custom cypher queries" do
    
    it "should only return the first two records" do
      Person.create(:name => 'Neo', :human => true)
      Person.create(:name => 'Trinity', :human => true)
      Person.create(:name => 'Morpheus', :human => true)
      results = Person.find_by_cypher("start s=node(:person_root) match s<-[:model_type]-d return d limit 2", 'd')
      results.size.should == 2
      results.first.should be_a(Person)
    end
    
    it "should return all native objects from queries" do
      neo = Person.create(:name => 'Neo', :human => true)
      niobe = Person.create(:name => 'Niobe', :human => true)
      logos = Ship.create(:name => 'Logos', :crew_size => 2)
      
      CrewMembership.new(logos, niobe, { :rank => 'Captain' })
      CrewMembership.new(logos, neo, { :rank => 'Member' })
      
      #results = Person.find_by_cypher("start s=node(#{logos.id}) match s-[r:model_type]->d return r,d", ['r', 'd'])
      #puts ">>> #{results.inspect}"
      pending
      
    end
    
  end
  
end
