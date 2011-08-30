require 'rspec'
require 'architect4r'

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
  config.formatter     = 'documentation'
  #c.filter_run_excluding :slow => true
  
  config.before(:suite) do
    # prepare database
  end
  
  config.after(:suite) do
    # cleanup database
  end
end

class TestNodeWithCastedProperties < Architect4r::Model::Node
  use_server TEST_SERVER
  
  property :name, :cast_to => String
  property :age, :cast_to => Integer
  property :active, :cast_to => TrueClass
end