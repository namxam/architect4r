require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  describe 'required rest methods' do
    it { should respond_to(:get) }
    it { should respond_to(:post) }
    it { should respond_to(:put) }
    it { should respond_to(:delete) }
  end
  
  its(:configuration) { should be_a(Architect4r::Core::Configuration) }
  
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
      #results = subject.execute_cypher("start node = (0) return node,node.name?")
      #results.should_not be_empty
      pending
    end
    
  end
  
  describe "relationship methods" do
    
    it "should retrieve all relationships" do
      subject.get_node_relationships(0).should be_a(Array)
    end
    
    it "should create a new relationship" do
      result = subject.create_relationship(0, 1, 'category', {'age' => '10', 'name' => 'mike'})
      result.should be_a(Hash)
      subject.delete_relationship(result['self'])
    end
    
  end
  
end