require 'spec_helper'

describe "Model properties based on test class Person" do
  
  describe "casting properties" do
    
    subject { Person.new }
    
    it "should cast strings to integers" do
      subject.age_when_enlightend = "4"
      subject.age_when_enlightend.should == 4
    end
    
    it "should cast the integer 1 to boolean true" do
      subject.human = 1
      subject.human.should == true
    end
    
    it "should cast the integer 0 to boolean false" do
      subject.human = 0
      subject.human.should == false
    end
    
    it "should cast the string 'true' to boolean true" do
      subject.human = "true"
      subject.human.should == true
    end
    
    it "should cast the string 'false' to boolean false" do
      subject.human = "false"
      subject.human.should == false
    end
    
    it "should cast the string '1' to boolean true" do
      subject.human = "1"
      subject.human.should == true
    end
    
    it "should cast the string '0' to boolean false" do
      subject.human = "0"
      subject.human.should == false
    end
    
    it "should create a ? method for boolean attributes" do
      subject.human = true
      subject.should respond_to(:human?)
      subject.human?.should == true
    end
    
  end
  
  describe "are nullified" do
    
    context "when no property value is set" do
      subject { Person.new }
      
      its(:name) { should be_nil }
      its(:age_when_enlightend) { should be_nil }
      its(:human) { should be_nil }
      
    end
    
    context "when setting property value to nil" do
      subject { Person.new(:name => 'Neo', :age_when_enlightend => 23, :human => true) }
      
      it "should remove nil strings" do
        subject.name = nil
        subject.name.should be_nil
      end
    end
    
  end
  
  describe "database properties json" do
    
    subject { Person }
    
    it "should include the type when casted to database hash" do
      obj = subject.new
      data_hash = obj.send(:_to_database_hash)
      data_hash['architect4r_type'].should == 'Person'
    end
    
    it "should include all valid properties" do
      obj = subject.new('name' => 'Neo', 'size' => 3)
      data_hash = obj.send(:_to_database_hash)
      data_hash['name'].should == 'Neo'
      data_hash.has_key?('size').should be_false
      data_hash.has_key?('human').should be_false
      data_hash.keys.size.should == 2
    end
    
    it "should not include nil values" do
      obj = subject.new(:name => 'Max Mustermann')
      obj.send(:_to_database_hash).has_key?(:age).should be_false
    end
    
  end
  
  describe "store in different localizations" do
    
    subject { Person.new }
    
    it "should provide a list of available locales"
    
    it "should allow specifying a default locale"
    
    it "should return the localized version based on the I18n locale" do
      subject.write_attribute(:vita, "Neo the savior", :en)
      subject.write_attribute(:vita, "Neo der Retter", :de)
      
      I18n.locale = :en
      subject.vita.should == "Neo the savior"
      
      I18n.locale = :de
      subject.vita.should == "Neo der Retter"
    end
    
    it "should fall back to the default value if no other is present" do
      subject.write_attribute(:vita, "Hello there", :en)
      # do not set a german title
      
      I18n.locale = :de
      subject.vita.should == "Hello there"
    end
    
    it "should not fall back to another localized value if not wanted" do
      subject.write_attribute(:note, "This is my description", :en)
      # do not set a german description
      
      I18n.locale = :de
      subject.note.should be_nil
      I18n.locale = :en
      subject.note.should == "This is my description"
    end
    
    it "should allow to force the returned locale" do
      subject.write_attribute(:vita, "Hello there", :en)
      subject.write_attribute(:vita, "Hallo du da", :de)
      
      subject.read_attribute(:vita, :en).should == "Hello there"
      subject.read_attribute(:vita, :de).should == "Hallo du da"
    end
    
    it "should set the localized version based on the I18n locale" do
      I18n.locale = :en
      subject.vita = "Hello there"
      
      I18n.locale = :de
      subject.vita = "Hallo du da"
      
      subject.read_attribute('vita_en').should == "Hello there"
      subject.read_attribute('vita_de').should == "Hallo du da"
    end
    
    it "should allow to force the locale in the setter" do
      subject.write_attribute(:vita, "Hello there", :en)
      subject.write_attribute(:vita, "Hallo du da", :de)
      
      subject.read_attribute('vita_en').should == "Hello there"
      subject.read_attribute('vita_de').should == "Hallo du da"
    end
    
  end
  
end