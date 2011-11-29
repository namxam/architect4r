require "spec_helper"

describe Architect4r::Model::LinksQueryInterface do
  
  before(:all) { @node = Person.create(:name => 'Neo') }
  after(:all) { @node.destroy }
  
  subject { Architect4r::Model::LinksQueryInterface.new(@node) }
  
  it { should respond_to :incoming }
  it { should respond_to :outgoing }
  it { should respond_to :both }
end