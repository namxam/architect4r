require 'spec_helper'

describe Architect4r::HasNode do
  
  subject { SomeDatabaseModel.new }
  
  describe "setup" do
    
    it "should have a node method" do
      subject.should respond_to(:node)
    end
    
    it "should have a architect4r_create_node method" do
      subject.should respond_to(:architect4r_create_node)
    end
    
    it "should have a architect4r_destroy_node method" do
      subject.should respond_to(:architect4r_destroy_node)
    end
    
    it "should have a architect4r_sync_node method" do
      subject.should respond_to(:architect4r_sync_node)
    end
    
  end
  
  describe "node retrieval" do
    
    it "should return nil if the parent record does not have an id" do
      subject.should_receive(:id).and_return(nil)
      subject.node.should be_nil
    end
    
    it "should try to retrieve the node when an id is present" do
      mock_node = mock(SomeDatabaseModelNode)
      subject.should_receive(:id).at_least(2).times.and_return(1)
      SomeDatabaseModelNode.should_receive(:find_by_cypher).at_least(1).times.and_return(mock(:first => mock_node))
      subject.node.should == mock_node
    end
    
  end
  
  describe "node creation" do
    
    it "should not create a new node if there is no record id" do
      subject.should_receive(:id).and_return(nil)
      subject.architect4r_create_node.should be_nil
    end
    
    it "should trigger the node creating after create" do
      subject.should_receive(:architect4r_create_node).once
      subject.create
    end
    
    it "should create a sync node" do
      subject.id = 2
      subject.name = 'My little test'
      subject.create
      subject.node.should be_a(SomeDatabaseModelNode)
    end
    
    it "should check the node for required attributes" do
      pending
    end
    
    it "should save the sync attributes when creating the node" do
      subject.id = 3
      subject.name = "My little test"
      subject.create
      subject.node.name.should == subject.name
    end
    
  end
  
  describe "node sync" do
    it "should store the changed attributes to the node" do
      subject.id = 4
      subject.name = "My sync test"
      subject.create
      subject.node.name.should == subject.name
      subject.name = "My changed sync test"
      subject.update
      subject.node.name.should == subject.name
    end
  end
  
end