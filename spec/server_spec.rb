require 'spec_helper'

describe Architect4r::Server do
  
  subject { Architect4r::Server.new }
  
  describe 'required rest methods' do
    it { should respond_to(:get) }
    it { should respond_to(:post) }
    it { should respond_to(:put) }
    it { should respond_to(:delete) }
  end
  
  describe :get do
    
    it "should be nil for invalid urls" do
      subject.get('/kjsdhf').should be_nil
    end
    
    it "should handle unauthorized requests" do
      # the root node has a reference_node property
      subject.get('/').key?('reference_node').should be_true
    end
    
    it "should use basic authentication"
    
    it "should use digest authentication"
    
  end
  
  it "should create a node" do
    result = subject.create_node({ 'name' => 'My test node', 'friends' => 13 })
    result.should be_a(Hash)
    result['self'].should be_a(String)
  end
  
  it "should get a node" do
    result = subject.get_node(1)
    result.should be_a(Hash)
    result['self'].should be_a(String)
  end
  
  it "should delete a node" do
    # Create a node which can be deleted
    node = subject.create_node({ 'test' => 'test' })
    node.should be_a(Hash)
    
    # Delete the node
    subject.delete_node(node['self'])
    
    # Check if it still exists
    subject.get_node(node['self']).should be_nil
  end
  
  it "should update a nodes properties" do
    # Create a node which can be deleted
    original_node = subject.create_node({ 'test1' => 'test', 'test2' => 'hello' })
    original_node.should be_a(Hash)
    
    # Update some attributes
    result = subject.update_node(original_node['self'], { 'test1' => 'world', 'test3' => 'word'})
    result.should be_true
    
    # check result
    changed_node = subject.get_node(original_node['self'])
    changed_node['data']['test1'].should == 'world'
    changed_node['data'].has_key?('test2').should be_false
    changed_node['data']['test3'].should == 'word'
  end
  
  describe :execute_cypher do
    
    it "should return an array of nodes" do
      # nodes
      #results = subject.find_by_cypher("start root = (#{subject.root_node.id}) match (root)-[r:model_root]->(x) return r")
      pending
    end
    
    it "should return an array of relationships" do
      # relations
      #results = subject.find_by_cypher("start root = (#{subject.root_node.id}) match (root)-[r:model_root]->(x) return r")
      pending
    end
    
    it "should the data unprocessed" do
      results = subject.execute_cypher("start node = (0) return node,node.name?")
      results.should_not be_empty
    end
    
  end
  
end