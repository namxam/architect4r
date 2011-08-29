require 'spec_helper'

describe "Persistency extension" do
  
  describe :create do
    
    subject { TestNodeWithCastedProperties.new }
    
    it "should create a new node" do
      subject.name = 'Max Mustermann'
      subject.age = 18
      subject.create.should be_true
    end
    
    it "should save a new node" do
      subject.name = 'Max Mustermann'
      subject.age = 18
      subject.save.should be_true
    end
    
  end
  
  describe :update do
    
    before(:all) do
      @node = TestNodeWithCastedProperties.new(:name => 'Max Mustermann')
      @node.create
    end
    
    after(:all) do
      @node.destroy
    end
    
    subject { @node }
    
    it "should update the name" do
      subject.name = "Lisa von Pisa"
      subject.update.should be_true
      subject.name.should == "Lisa von Pisa"
      
      reloaded = TestNodeWithCastedProperties.find_by_id(subject.id)
      reloaded.name.should == "Lisa von Pisa"
    end
    
    it "should add new properties" do
      subject.age.should be_nil
      subject.age = 18
      subject.update.should be_true
      subject.age.should == 18
      
      reloaded = TestNodeWithCastedProperties.find_by_id(subject.id)
      reloaded.age.should == 18
    end
    
    it "should remove empty properties" do
      subject.name.should_not be_nil
      subject.name = nil
      
      subject.update.should be_true
      subject.name.should be_nil
      
      reloaded = TestNodeWithCastedProperties.find_by_id(subject.id)
      reloaded.name.should be_nil
    end
    
  end
  
  describe :delete do
    
    subject { TestNodeWithCastedProperties.create(:name => 'Max Mustermann') }
    
    it "should delete an existing node" do
      deleted_id = subject.id
      subject.destroy.should be_true
      TestNodeWithCastedProperties.find_by_id(deleted_id).should be_nil
    end
    
    it "should mark the object as deleted" do
      subject.destroy.should be_true
      subject.destroyed?.should be_true
    end
    
    it "should not be possible to update a deleted object" do
      subject.destroy.should be_true
      expect { subject.update }.to raise_error
    end
    
    it "should delete an existing node with relationships"
    
  end
  
  describe :new? do
    
    subject { TestNodeWithCastedProperties.new }
    
    it "should be true if its a new record" do
      subject.new?.should be_true
    end
    
    it "should be false if the record is created" do
      subject.create
      subject.new?.should be_false
    end
    
  end
  
end