require 'rspec'
require 'architect4r'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  #c.filter_run_excluding :slow => true
end