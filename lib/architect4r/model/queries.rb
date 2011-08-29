module Architect4r
  module Model
    module Queries
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
      end
      
      module ClassMethods
        
        def all(opts = {}, &block)
          raise 'not implemented'
        end
        
        def count(opts = {}, &block)
          raise 'not implemented'
        end
        
        def first(opts = {})
          raise 'not implemented'
        end
        
        def last(opts = {})
          raise 'not implemented'
        end
        
        def find_by_id(id)
          self.build_from_database(connection.get_node(id))
        end
        
        def find_by_id!(id)
          raise 'not implemented'
        end
        
      end
    end
  end
end