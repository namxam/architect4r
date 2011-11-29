require 'bundler/gem_tasks'

# Add rspec tasks for testing
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

# Load instance manager
require './lib/architect4r/instance_manager'

# Setting up default tasks
desc "Run specs"
task :default => :spec

namespace :server do
  
  current_path = File.dirname(__FILE__)
  server_path = File.join(current_path, 'neo4j_server')
  neo_manager = Architect4r::InstanceManager.new(server_path)
  
  desc "Install test server"
  task :install do
    puts '--- not implemented'
  end
  
  desc "Stop the neo4j server"
  task :start do
    neo_manager.start
  end
  
  desc "Stop the neo4j server"
  task :stop do
    neo_manager.stop
  end
  
  desc "Reset the test server"
  task :reset do
    neo_manager.reset_to_sample_data("#{current_path}/spec/fixtures/graph.db.default/")
  end
  
end
