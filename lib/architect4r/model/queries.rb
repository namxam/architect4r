module Architect4r
  module Model
    module Queries
      extend ActiveSupport::Concern
      
      module ClassMethods
        
        def count(opts = {}, &block)
          data = connection.execute_cypher("start s=node(#{self.model_root.id}) match (s)<-[:model_type]-(d) return count(d)")
          data['data'].flatten.first
        end
        
        # Fetch a record of the specified model based on its id
        #
        def find(*ids)
          # This code is taken from / inspired by activerecord:
          #   activerecord/lib/active_record/base.rb, line 1589
          expects_array = ids.first.kind_of?(Array)
          return ids.first if expects_array && ids.first.empty?
          
          ids = ids.flatten.compact.uniq
          
          case ids.size
          when 0
            raise(Architect4r::RecordNotFound.new("Could not find the #{self.name} without an id!"))
          when 1
            id = ids.first.to_i
            data = connection.execute_cypher("start s=node(#{self.model_root.id}), d=node(#{id}) match s<-[r:model_type]-d return d")
            data &&= data['data'] && data['data'].flatten.first
            result = self.build_from_database(data)
            
            expects_array ? [ result ] : result
          else
            ids = ids.map { |i| i.to_i }.uniq.join(',')
            find_by_cypher("start s=node(#{self.model_root.id}), d=node(#{ids}) match s<-[r:model_type]-d return d", 'd')
          end
        end
        alias :find_by_id :find
        
        def find!(id)
          self.find(id) || raise(Architect4r::RecordNotFound.new("Could not find the #{self.name} with id #{id}!"))
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