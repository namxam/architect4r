require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  before(:all) do
    # Lets create two nodes we can work with
    @node1 = subject.create_node({ 'name' => 'first test node' })
    @node2 = subject.create_node({ 'name' => 'first test node' })
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
  
  it "should retrieve all relationships" do
    subject.get_node_relationships(0).should be_a(Array)
  end

end
