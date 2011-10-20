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

end
