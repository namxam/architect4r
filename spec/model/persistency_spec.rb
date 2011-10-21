require 'spec_helper'

describe "Persistency extension" do
  
  describe :create do
    
    subject { Person.new }
    
    it "should create a new node" do
      subject.name = 'Neo'
      subject.human = true
      subject.create.should be_true
    end
    
    it "should save a new node" do
      subject.name = 'Neo'
      subject.human = true
      subject.save.should be_true
    end
    
  end
  
  describe :update do
    
    before(:all) do
      @node = Person.new(:name => 'Neo', :human => true, :note => 'Important person')
      @node.create
    end
    
    after(:all) do
      @node.destroy
    end
    
    subject { @node }
    
    it "should update the name" do
      subject.name = "Agent Smith"
      subject.update.should be_true
      subject.name.should == "Agent Smith"
      
      reloaded = Person.find_by_id(subject.id)
      reloaded.name.should == "Agent Smith"
    end
    
    it "should add new properties" do
      subject.age_when_enlightend.should be_nil
      subject.age_when_enlightend = 18
      subject.update.should be_true
      subject.age_when_enlightend.should == 18
      
      reloaded = Person.find_by_id(subject.id)
      reloaded.age_when_enlightend.should == 18
    end
    
    it "should remove empty properties" do
      subject.note.should_not be_nil
      subject.note = nil
      
      subject.update.should be_true
      subject.note.should be_nil
      
      reloaded = Person.find_by_id(subject.id)
      reloaded.note.should be_nil
    end
    
  end
  
  describe :delete do
    
    subject { Person.create(:name => 'Max Mustermann', :human => true) }
    
    it "should delete an existing node" do
      deleted_id = subject.id
      subject.destroy.should be_true
      Person.find_by_id(deleted_id).should be_nil
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
    
    subject { Person.new(:name => 'Name', :human => true) }
    
    it "should be true if its a new record" do
      subject.new?.should be_true
    end
    
    it "should be false if the record is created" do
      subject.create
      subject.new?.should be_false
      subject.destroy
    end
    
  end
  
end