module Architect4r
  module Model
    module Queries
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
      end
      
      module ClassMethods
        
        def count(opts = {}, &block)
          data = connection.execute_cypher("start s=node(#{self.model_root.id}) match (s)<-[:model_type]-(d) return count(d)")
          data['data'].flatten.first
        end
        
        # Fetch a record of the specified model based on its id
        #
        def find(id)
          data = connection.execute_cypher("start s=node(#{self.model_root.id}), d=node(#{id.to_i}) match s<-[r:model_type]-d return d")
          data &&= data['data'] && data['data'].flatten.first
          self.build_from_database(data)
        end
        alias :find_by_id :find
        
        def find!(id)
          self.find_by_id(id) || raise(Architect4r::RecordNotFound.new("Could not find the #{self.name} with id #{id}!"))
        end
        alias :find_by_id! :find!
        
        # Use this method only to fetch items of the same class.
        def find_by_cypher(query, identifier)
          if result_data = connection.execute_cypher(query)
            result_data = connection.transform_cypher_result_to_hash(result_data)
            result_data.map { |item| connection.convert_if_possible(item[identifier]) }
          else
            nil
          end
        end
        
        def all
          find_by_cypher("start ModelRoot=node(#{self.model_root.id}) match ModelRoot<-[:model_type]-Item return Item", 'Item')
        end
        
      end
    end
  end
end