require 'spec_helper'

describe Architect4r::Base do
  
  it 'should return correct version string' do
    Architect4r::Base.version.should == "Architect4r version #{Architect4r::VERSION}"
  end
  
  before { @base = Architect4r::Base.new }
  subject { @base }
  
  describe :hello_world do
    subject { @base.hello_world }
    it { should eql("This is working!") }
  end
  
end