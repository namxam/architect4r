require 'spec_helper'

describe "links to and from nodes" do
  
  before(:all) { @node = TestNodeWithCastedProperties.create(:name => 'A test node') }
  after(:all) { @node.destroy }
  
  it "should respond to :links" do
    @node.should respond_to(:links)
  end
  
  subject { @node.links }
  
  it "should respond to :incoming" do
    subject.should respond_to(:incoming)
  end
  
  it "should respond to :incoming" do
    subject.should respond_to(:outgoing)
  end
  
  it "should respond to :incoming" do
    subject.should respond_to(:both)
  end
  
end