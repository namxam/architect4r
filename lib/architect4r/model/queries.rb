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
          data = connection.execute_cypher("start s=node(#{self.model_root.id}), d=node(#{id.to_i}) match s<-[r:model_type]-d return d")
          data &&= data.first && data.first['d']
          self.build_from_database(data)
        end
        
        def find_by_id!(id)
          raise 'not implemented'
        end
        
      end
    end
  end
end