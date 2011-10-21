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

class Person < Architect4r::Model::Node
  use_server TEST_SERVER
  
  # Properties
  property :name, :cast_to => String
  property :human, :cast_to => TrueClass
  property :vita, :cast_to => String, :localize => :en
  property :birthday, :cast_to => Date
  property :age_when_enlightend, :cast_to => Integer
  property :note, :cast_to => String, :localize => true
  
  # Validations
  validates :name, :presence => true, :length => { :minimum => 3, :allow_nil => true }
  validates :human, :presence => true
  validates :age_when_enlightend, :numericality => { :allow_nil => true }
  
  # Instance methods
  def age
    birthday.present && ((Date.today - birthday).to_i / 365)
  end
end

class Ship < Architect4r::Model::Node
  use_server TEST_SERVER
  
  # Properties
  property :name, :cast_to => String
  property :working, :cast_to => TrueClass
  property :max_crew_size, :cast_to => Integer
  
  # Validations
  validates :name, :length => { :minimum => 3 }
  validates :max_crew_size, :numericality => true
end

class CrewMembership < Architect4r::Model::Relationship
  use_server TEST_SERVER
  
  # Properties
  property :member_since, :cast_to => DateTime
  property :rank, :cast_to => String
  
  # Validations
  #validates, :source, :type => Ship
  #validates, :destination, :type => Person
end