require 'spec_helper'

describe "Validations extension" do
  
  subject { LocalizedNodeWithValidations.new }
  
  its(:valid?) { should be_false }
  
  [:title, :description, :users_counter].each do |a|
    it "should list #{a} among its errors" do
      subject.valid?
      subject.errors.to_hash.has_key?(a).should be_true
    end
  end
  
  it "should not allow creating a record if it is invalid" do
    #subject.create.should be_false
    #subject.errors.size.should == 3
  end
  
  it "should not allow updating record if it is invalid" do
    subject.title = "Test"
    subject.description = "Some content"
    subject.users_counter = 0
    subject.create.should be_true
    
    subject.title = nil
    subject.update.should be_false
  end
  
end
