require "spec_helper"

describe Architect4r::Model::Relationship do
  
  it "should work" do
    fs = CrewMembership.new(:member_since => DateTime.new, :rank => 'Captain')
    fs.valid?.should be_true
  end
  
end
