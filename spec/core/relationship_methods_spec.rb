require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  before(:all) do
    # Lets create two nodes we can work with
    @node1 = subject.create_node({ 'name' => 'first test node' })
    @node2 = subject.create_node({ 'name' => 'second test node' })
  end
  
  after(:all) do
    # Lets create two nodes we can work with
    subject.delete_node(@node1)
    subject.delete_node(@node2)
  end
  
  it "should create and delete a new relationship" do
    result = subject.create_relationship(@node1, @node2, 'friendship', { 'reason' => 'Because I really like you!' })
    result.should be_a(Hash)
    subject.delete_relationship(result)
  end
  
  it "should allow creating relationships without properties" do
    result = subject.create_relationship(@node1, @node2, 'friendship')
    result.should be_a(Hash)
    subject.delete_relationship(result)
  end
  
  it "should allow filtering relationships by direction" do
    # create test nodes
    n1 = subject.create_node({ 'name' => 'first test node' })
    n2 = subject.create_node({ 'name' => 'second test node' })
    
    # create relationships
    subject.create_relationship(n1, n2, 'relation')
    subject.create_relationship(n1, n2, 'relation2')
    subject.create_relationship(n2, n1, 'relation3')
    
    # test node direction
    subject.get_node_relationships(n1).size.should == 3
    subject.get_node_relationships(n1, :all).size.should == 3
    subject.get_node_relationships(n1, :outgoing).size.should == 2
    subject.get_node_relationships(n1, :incoming).size.should == 1
    
    # test relation type
    subject.get_node_relationships(n1, :all, 'relation').size.should == 1
    subject.get_node_relationships(n1, :outgoing, 'relation').size.should == 1
    subject.get_node_relationships(n1, :incoming, 'relation').size.should == 0
    subject.get_node_relationships(n1, :all, 'relation', 'relation2').size.should == 2
    
    # Clean up
    subject.delete_node(n1)
    subject.delete_node(n2)
  end
  
  it "should retrieve all relationships" do
    subject.get_node_relationships(0).should be_a(Array)
  end
  
  it "should load a relationship" do
    node = subject.create_node({ 'name' => 'A test node' })
    rel = subject.create_relationship(node, node, 'test', { 'some' => 'data' })
    data = subject.get_relationship(rel)
    data.should be_a(Hash)
    data['data']['some'].should == 'data'
  end
  
  it "should update a nodes properties" do
    node = subject.create_node({ 'name' => 'A test node' })
    original_rel = subject.create_relationship(node, node, 'self-reference', { 'note' => 'Some random note', 'obsolete' => '1' })
    original_rel.should be_a(Hash)
    
    # Update some attributes
    result = subject.update_relationship(original_rel, { 'note' => 'Some changed note', 'highlight' => 'note'})
    result.should be_true
    
    # check result
    changed_rel = subject.get_relationship(original_rel)
    changed_rel['data']['note'].should == 'Some changed note'
    changed_rel['data'].has_key?('obsolete').should be_false
    changed_rel['data']['highlight'].should == 'note'
  end
  
  it "should know about all relationship types" do
    node = subject.create_node({ 'name' => 'A test node' })
    subject.create_relationship(node, node, 'self-reference')
    subject.get_relationship_types.should include('self-reference')
  end

end
