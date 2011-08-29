require 'rspec'
require 'architect4r'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  #c.filter_run_excluding :slow => true
end

class TestNodeWithCastedProperties < Architect4r::Model::Node
  property :name, :cast_to => String
  property :age, :cast_to => Integer
  property :active, :cast_to => TrueClass
end