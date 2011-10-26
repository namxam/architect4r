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
  
  describe :interpolate_node_model_root_references do
    
    it "should return the original query if there is nothing to interpolate" do
      result = subject.interpolate_node_model_root_references("start node(0) match something")
      result.should == "start node(0) match something"
    end
    
    it "should find and replace a single reference" do
      Person.should_receive(:model_root).and_return(stub(:id => 1))
      result = subject.interpolate_node_model_root_references("start node(:person_root) match something")
      result.should == "start node(1) match something"
    end
    
    it "should find and replace multiple references" do
      Person.should_receive(:model_root).and_return(stub(:id => 1))
      Ship.should_receive(:model_root).and_return(stub(:id => 2))
      result = subject.interpolate_node_model_root_references("start p=node(:person_root), s=node(:ship_root) match something")
      result.should == "start p=node(1), s=node(2) match something"
    end
    
    it "should find and replace multiple references to the same root" do
      Person.should_receive(:model_root).and_return(stub(:id => 1))
      result = subject.interpolate_node_model_root_references("start p=node(:person_root), s=node(:person_root) match something")
      result.should == "start p=node(1), s=node(1) match something"
    end
    
  end
  
end