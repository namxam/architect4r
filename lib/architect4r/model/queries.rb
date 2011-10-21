module Architect4r
  module Model
    module Queries
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
      end
      
      module ClassMethods
        
        def count(opts = {}, &block)
          data = connection.execute_cypher("start s=node(#{self.model_root.id}) match (s)<-[:model_type]-(d) return count(d)")
          data.first['count(d)']
        end
        
        def find_by_id(id)
          data = connection.execute_cypher("start s=node(#{self.model_root.id}), d=node(#{id.to_i}) match s<-[r:model_type]-d return d")
          data &&= data.first && data.first['d']
          self.build_from_database(data)
        end
        
        def find_by_id!(id)
          raise 'not implemented'
        end
        
        def find_by_cypher(query, identifier)
          if data = connection.execute_cypher(query)
            data.map { |item| build_from_database(item[identifier]) }
          else
            nil
          end
        end
        
      end
    end
  end
end