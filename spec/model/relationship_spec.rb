require "spec_helper"

describe Architect4r::Model::Relationship do
  
  it "should work" do
    fs = Fanship.new(:created_at => DateTime.new, :reason => 'Because I like you!')
    fs.valid?.should be_true
  end
  
end
