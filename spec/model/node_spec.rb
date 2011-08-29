require "spec_helper"

describe "Model Node" do
  
  subject { TestNodeWithCastedProperties }
  
  describe :new do
    
    it { should respond_to(:new) }
    
    it "should accept a hash of properties with strings as keys" do
      piano = subject.new({ 'name' => 'Piano' })
      piano.should respond_to(:name)
      piano.name.should eql('Piano')
    end
    
    it "should accept a hash of properties with symbols as keys" do
      piano = subject.new({ :name => 'Piano' })
      piano.should respond_to(:name)
      piano.name.should eql('Piano')
    end
  end
  
  describe "connection" do
    
    it { should respond_to(:connection) }
    
    its(:connection) { should respond_to(:get) }
    
  end
  
end