module Architect4r
  class InstanceManager
    
    def initialize(path)
      @path = path
    end
    
    def server_path
      @path
    end
    
    def start
      %x[#{server_path}/bin/neo4j start]
    end
    
    def stop
      %x[#{server_path}/bin/neo4j stop]
    end
    
    def restart
      %x[#{server_path}/bin/neo4j restart]
    end
    
    def reset
      self.stop
      
      # Reset the database
      FileUtils.rm_rf("#{server_path}/data/graph.db")
      FileUtils.mkdir("#{server_path}/data/graph.db")
      
      # Remove log files
      FileUtils.rm_rf("#{server_path}/data/log")
      FileUtils.mkdir("#{server_path}/data/log")
      
      # Start the server
      self.start
    end
    
    def reset_to_sample_data(from)
      self.stop
      FileUtils.rm_rf("#{server_path}/data/graph.db")
      FileUtils.cp_r(from, "#{server_path}/data/graph.db/")
      self.start
    end
    
  end
end