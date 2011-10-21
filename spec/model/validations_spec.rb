require 'spec_helper'

describe "Validations extension" do
  
  subject { Person.new }
  
  its(:valid?) { should be_false }
  
  [:name, :human].each do |a|
    it "should list #{a} among its errors" do
      subject.valid?
      subject.errors.to_hash.has_key?(a).should be_true
    end
  end
  
  it "should not allow creating a record if it is invalid" do
    subject.create.should be_false
    subject.errors.size.should == 2
  end
  
  it "should not allow updating record if it is invalid" do
    subject.name = "Neo"
    subject.human = true
    subject.vita = "Bad ass charcater who kicks everybody's ass."
    subject.create.should be_true
    
    subject.name = nil
    subject.update.should be_false
  end
  
end
