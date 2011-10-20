require 'rspec'
require 'rake'
require 'architect4r'
require 'architect4r/instance_manager'

unless defined?(TEST_SERVER)
  TEST_SERVER_CONFIG = {
    :environment => :test,
    :config => {
      :host => 'localhost', 
      :port => '7475', 
      :path => '', 
      :log_level => 'OFF'
    }
  }
  
  TEST_SERVER = Architect4r::Server.new(TEST_SERVER_CONFIG)
end

RSpec.configure do |config|
  config.color_enabled = true
  #config.formatter     = 'documentation'
  #c.filter_run_excluding :slow => true
  
  neo_manager = Architect4r::InstanceManager.new(File.join(File.dirname(__FILE__), '../neo4j_server'))
  
  config.before(:suite) do
    neo_manager.reset_to_sample_data(File.join(File.dirname(__FILE__), "fixtures/graph.db.default/"))
    
    #subject.create_node({ 'name' => 'My test node', 'friends' => 13 })
  end
  
  config.after(:suite) do
    neo_manager.start
  end
end

class TestNodeWithCastedProperties < Architect4r::Model::Node
  use_server TEST_SERVER
  
  property :name, :cast_to => String
  property :age, :cast_to => Integer
  property :active, :cast_to => TrueClass
end

class LocalizedNodeWithProperties < Architect4r::Model::Node
  use_server TEST_SERVER
  
  # Property with default localization
  property :title, :cast_to => String, :localize => :en
  
  # Property with no default localization
  property :description, :cast_to => String, :localize => true
end

class LocalizedNodeWithValidations < Architect4r::Model::Node
  use_server TEST_SERVER
  
  # Properties
  property :title, :cast_to => String, :localize => :en
  property :description, :cast_to => String, :localize => true
  property :users_counter, :cast_to => Integer
  
  # Validations
  validates_presence_of :title#, :presence => true
  validates :description, :length => { :minimum => 3, :allow_null => true }
  validates :users_counter, :numericality => true
end

class Fanship < Architect4r::Model::Node
  use_server TEST_SERVER
  
  # Properties
  property :created_at, :cast_to => DateTime
  property :reason, :cast_to => String
end