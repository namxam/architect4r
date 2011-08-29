require 'spec_helper'

describe "Model properties based on test class TestNodeWithCastedProperties" do
  
  describe "casting properties" do
    
    subject { TestNodeWithCastedProperties.new }
    
    it "should cast strings to integers" do
      subject.age = "4"
      subject.age.should == 4
    end
    
    it "should cast the integer 1 to boolean true" do
      subject.active = 1
      subject.active.should == true
    end
    
    it "should cast the integer 0 to boolean false" do
      subject.active = 0
      subject.active.should == false
    end
    
    it "should cast the string 'true' to boolean true" do
      subject.active = "true"
      subject.active.should == true
    end
    
    it "should cast the string 'false' to boolean false" do
      subject.active = "false"
      subject.active.should == false
    end
    
    it "should cast the string '1' to boolean true" do
      subject.active = "1"
      subject.active.should == true
    end
    
    it "should cast the string '0' to boolean false" do
      subject.active = "0"
      subject.active.should == false
    end
    
    it "should create a ? method for boolean attributes" do
      subject.active = true
      subject.should respond_to(:active?)
      subject.active?.should == true
    end
    
  end
  
  describe "are nullified" do
    
    context "when no property value is set" do
      subject { TestNodeWithCastedProperties.new }
      
      its(:name) { should be_nil }
      its(:age) { should be_nil }
      its(:active) { should be_nil }
      
    end
    
    context "when setting property value to nil" do
      subject { TestNodeWithCastedProperties.new(:name => 'Max Mustermann', :age => 18, :active => true) }
      
      it "should remove nil strings" do
        subject.name = nil
        subject.name.should be_nil
      end
    end
    
  end
  
  describe "database properties json" do
    
    subject { TestNodeWithCastedProperties }
    
    it "should include the type when casted to database hash" do
      obj = subject.new
      data_hash = obj.send(:_to_database_hash)
      data_hash['architect4r_type'].should == 'TestNodeWithCastedProperties'
    end
    
    it "should include all valid properties" do
      obj = subject.new('name' => 'Piano', 'size' => 3)
      data_hash = obj.send(:_to_database_hash)
      data_hash['name'].should == 'Piano'
      data_hash.has_key?('size').should be_false
      data_hash.has_key?('active').should be_false
      data_hash.keys.size.should == 2
    end
    
    it "should not include nil values" do
      obj = subject.new(:name => 'Max Mustermann')
      obj.send(:_to_database_hash).has_key?(:age).should be_false
    end
    
  end
  
end