require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  it "should create a node" do
    result = subject.create_node({ 'name' => 'My test node', 'friends' => 13 })
    result.should be_a(Hash)
    result['self'].should be_a(String)
  end
  
  it "should get a node" do
    result = subject.get_node(0)
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

end