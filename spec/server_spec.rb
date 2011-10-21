require 'spec_helper'

describe Architect4r::Server do
  
  subject { TEST_SERVER }
  
  describe 'required rest methods' do
    it { should respond_to(:get) }
    it { should respond_to(:post) }
    it { should respond_to(:put) }
    it { should respond_to(:delete) }
  end
  
  its(:configuration) { should be_a(Architect4r::Core::Configuration) }
  
  describe :get do
    
    it "should be nil for invalid urls" do
      subject.get('/kjsdhf').should be_nil
    end
    
    it "should handle unauthorized requests" do
      # the root node has a reference_node property
      subject.get('/').key?('reference_node').should be_true
    end
    
    it "should use basic authentication"
    
    it "should use digest authentication"
    
  end
  
end