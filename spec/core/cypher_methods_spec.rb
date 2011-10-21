require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  describe :execute_cypher do
    
    it "should return an array of nodes" do
      # nodes
      #results = subject.execute_cypher("start root = (#{subject.root_node.id}) match (root)-[r:model_root]->(x) return r")
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
  
end