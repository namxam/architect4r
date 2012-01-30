require "spec_helper"

describe "Model Node" do
  
  subject { Person }
  
  describe :new do
    
    it { should respond_to(:new) }
    
    it "should accept a hash of properties with strings as keys" do
      piano = subject.new({ 'name' => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
    
    it "should accept a hash of properties with symbols as keys" do
      piano = subject.new({ :name => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
  end
  
  describe "#to_s" do
    
    it "should provide a more readable representation of the object" do
      person = Person.create(:name => 'Morpheus', :human => true)
      person.to_s.should == "#<Person:#{person.object_id} id=#{person.id} name='Morpheus' created_at='#{person.created_at}' human='true' updated_at='#{person.updated_at}' neo4j_uri='#{TEST_SERVER.node_url(person.id)}'>"
    end
    
  end
  
  describe "connection" do
    
    it { should respond_to(:connection) }
    
    its(:connection) { should respond_to(:get) }
    
  end
  
  describe "node model_root" do
    
    it "should create a model_root node if there is none" do
      Person.create(:name => 'Morpheus', :human => true)
      Person.model_root.should_not be_nil
    end
    
    it "should reuse an existing model_root if there is already one" do
      Person.create(:name => 'Morpheus', :human => true)
      m_root = Person.model_root
      Person.create(:name => 'Trinity', :human => true)
      Person.model_root.id.should == m_root.id
    end
    
  end
  
end