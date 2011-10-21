require "spec_helper"

describe "Model Node" do
  
  subject { Person }
  
  describe :new do
    
    it { should respond_to(:new) }
    
    it "should accept a hash of properties with strings as keys" do
      piano = subject.new({ 'name' => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
    
    it "should accept a hash of properties with symbols as keys" do
      piano = subject.new({ :name => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
  end
  
  describe "connection" do
    
    it { should respond_to(:connection) }
    
    its(:connection) { should respond_to(:get) }
    
  end
  
end