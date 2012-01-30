require 'rspec'
require 'rake'
#require 'active_record'
require 'architect4r'
require 'architect4r/instance_manager'

unless defined?(TEST_SERVER)
  TEST_SERVER_CONFIG = {
    :environment => :test,
    :config => {
      :host => 'localhost', 
      :port => '7474', 
      :path => '', 
      :log_level => 'OFF'
    }
  }
  
  TEST_SERVER = Architect4r::Server.new(TEST_SERVER_CONFIG)
end

RSpec.configure do |config|
  config.color_enabled = true
  neo_manager = Architect4r::InstanceManager.new(File.join(File.dirname(__FILE__), '../neo4j_server'))
  
  config.before(:suite) do
    neo_manager.reset
    neo_manager.start
  end
  
  config.after(:suite) do
    neo_manager.stop
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
  timestamps!
  
  # Validations
  validates :name, :presence => true, :length => { :minimum => 3, :allow_nil => true }
  validates :human, :inclusion =>  { :in => [true, false] }
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
  property :crew_size, :cast_to => Integer
  
  # Validations
  validates :name, :length => { :minimum => 3 }
  validates :crew_size, :numericality => true
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

class SomeDatabaseModelNode < Architect4r::Model::Node
 use_server TEST_SERVER
 property :name, :cast_to => String
end

class SomeDatabaseModel
  
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :update, :destroy
  
  # Init architect4r integration
  include Architect4r::HasNode
  has_node :node, SomeDatabaseModelNode, :sync => [:name]
  
  attr_accessor :id, :name
  
  def create(attributes={})
    run_callbacks :create do
      true
    end
  end
  
  def destroy
    run_callbacks :destroy do
      true
    end
  end
  
  def update
    run_callbacks :update do
      true
    end
  end
  
end