require 'spec_helper'

describe Architect4r do
  
  it 'should return correct version string' do
    Architect4r.version.should == "Architect4r version #{Architect4r::VERSION}"
  end
  
end