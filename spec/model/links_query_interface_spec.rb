require "spec_helper"

describe Architect4r::Model::LinksQueryInterface do
  
  before(:all) { @node = TestNodeWithCastedProperties.create(:name => 'A test node') }
  after(:all) { @node.destroy }
  
  subject { Architect4r::Model::LinksQueryInterface.new(@node) }
  
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