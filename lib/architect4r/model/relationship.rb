module Architect4r
  module Model
    class Relationship
      
      #
      # Extensions
      #
      include Architect4r::Model::Connection
      include Architect4r::Model::Callbacks
      include Architect4r::Model::Persistency
      
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
        
        subklass.class_exec do
          # Validations
          validates :source, :presence => true
          validates :destination, :presence => true
        end
      end
      
      #
      # Virtual attributes
      #
      attr_accessor :source, :destination, :raw_data
      
      #
      # Instance methods
      #
      
      def initialize(*args)
        # Detect source and destination
        if s = args[0].is_a?(Architect4r::Model::Node) && args.shift
          self.source = s
          
          if d = args[0].is_a?(Architect4r::Model::Node) && args.shift
            self.destination = d
          end
        end
        
        # Detect properties
        properties = args[0].is_a?(Hash) && args.shift
        properties ||= {}
        parse_properties(properties)
      end
      
      # Create the document. Validation is enabled by default and will return
      # false if the document is not valid. If all goes well, the document will
      # be returned.
      def create(options = {})
        run_callbacks :create do
          run_callbacks :save do
            # only create valid records
            return false unless perform_validations(options)
            
            # perform creation
            if result = connection.create_relationship(self.source.id, self.destination.id, self.class.name, self._to_database_hash)
              self.raw_data = result
            end
            
            # if something goes wrong we receive a nil value and return false
            !result.nil?
          end
        end
      end
      
      # Trigger the callbacks (before, after, around)
      # only if the document isn't new
      def update(options = {})
        run_callbacks :update do
          run_callbacks :save do
            # Check if record can be updated
            raise "Cannot save a destroyed document!" if destroyed?
            raise "Calling #{self.class.name}#update on document that has not been created!" if new?
            
            # Check if we can continue
            return false unless perform_validations(options)
            
            # perform update
            result = connection.update_relationship(self.id, self._to_database_hash)
            
            # if something goes wrong we receive a nil value and return false
            !result.nil?
          end
        end
      end
      
      def destroy
        run_callbacks :destroy do
          if result = connection.delete_relationship(self.id)
            @_destroyed = true
            self.freeze
          end
          result
        end
      end
      
    end
  end
end