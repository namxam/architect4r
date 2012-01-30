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
  
  # Install is partialy taken the https://github.com/maxdemarzi/neography/blob/master/lib/neography/tasks.rb
  # But only Unix part of it for now
  desc "Install test server"
  task :install do
    puts "Installing Neo4j server (community edition)..."
    %x[wget http://dist.neo4j.org/neo4j-community-1.5-unix.tar.gz]
    %x[tar -xvzf neo4j-community-1.5-unix.tar.gz]
    %x[mv neo4j-community-1.5 neo4j_server]
    %x[rm neo4j-community-1.5-unix.tar.gz]
    puts "Neo4j Installed in to neo4j_server directory."
    puts "Type 'rake server:start' to start it or 'rake server:stop' to stop"
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
