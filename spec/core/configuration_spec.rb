require 'spec_helper'

describe Architect4r::Core::Configuration do
  
  describe "default configuration" do
    subject { Architect4r::Core::Configuration.new }
    
    its(:host) { should == 'localhost' }
    its(:port) { should == 7474 }
    its(:path) { should == '' }
    its(:log_level) { should == 'INFO' }
    
    context "in test environment" do
      subject { Architect4r::Core::Configuration.new(:environment => :test) }
      
      its(:host) { should == 'localhost' }
      its(:port) { should == 7475 }
      its(:path) { should == '' }
      its(:log_level) { should == 'OFF' }
    end
    
    context "in production environment" do
      subject { Architect4r::Core::Configuration.new(:environment => :production) }
      
      its(:host) { should == 'localhost' }
      its(:port) { should == 7474 }
      its(:path) { should == '' }
      its(:log_level) { should == 'WARNING' }
    end
    
  end
  
  describe "provided by hash" do
    subject { Architect4r::Core::Configuration.new(:environment => :development, :config => { :host => 'neo4j.local', :port => '80', :path => 'dev', :log_level => 'ERROR', :log_file => '/tmp/neo.log' }) }
    
    its(:host) { should == 'neo4j.local' }
    its(:port) { should == 80 }
    its(:path) { should == 'dev' }
    its(:log_level) { should == 'ERROR' }
    its(:log_file) { should == '/tmp/neo.log' }
    
  end
  
  describe "provided by a custom config file" do
    subject { Architect4r::Core::Configuration.new(:environment => :staging, :config => File.join(Dir.pwd, 'spec', 'fixtures', 'architect4r.yml')) }
    
    its(:host) { should == 'staging.dev' }
    its(:port) { should == 8080 }
    its(:path) { should == 'my_neo_instance' }
    its(:log_level) { should == 'WARNING' }
    
  end
  
end