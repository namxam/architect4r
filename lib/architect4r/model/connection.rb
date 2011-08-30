module Architect4r
  module Model
    module Connection
      extend ActiveSupport::Concern
      
      module InstanceMethods
      
        def connection
          self.class.connection
        end
        
      end
      
      module ClassMethods
        
        def use_server(server)
          @connection = server
        end
        
        def connection
          # TODO: apply configuration
          @connection || Server.new
        end
        
      end
      
    end
  end
end