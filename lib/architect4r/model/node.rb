module Architect4r
  
  module Model
    
    class Node
      include Architect4r::Model::Connection
      include Architect4r::Model::Persistency
      include Architect4r::Model::Queries
      include Architect4r::Model::Relationships
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
      end
      
      attr_accessor :raw_data
      
      def initialize(properties={})
        parse_properties(properties)
      end
      
      # Create the document. Validation is enabled by default and will return
      # false if the document is not valid. If all goes well, the document will
      # be returned.
      def create(options = {})
        # only create valid records
        return false unless perform_validations(options)
        
        # perform creation
        if result = connection.create_node(self._to_database_hash)
          self.raw_data = result
        end
        
        # if something goes wrong we receive a nil value and return false
        !result.nil?
      end
      
      # Trigger the callbacks (before, after, around)
      # only if the document isn't new
      def update(options = {})
        # Check if record can be updated
        raise "Cannot save a destroyed document!" if destroyed?
        raise "Calling #{self.class.name}#update on document that has not been created!" if new?
        
        # Check if we can continue
        return false unless perform_validations(options)
        
        # perform update
        result = connection.update_node(self.id, self._to_database_hash)
        
        # if something goes wrong we receive a nil value and return false
        !result.nil?
      end
      
      def destroy
        if result = connection.delete_node(self.id)
          @_destroyed = true
          self.freeze
        end
        result
      end
      
    end
    
  end
  
end