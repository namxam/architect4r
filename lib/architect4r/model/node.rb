module Architect4r
  
  module Model
    
    class Node
      include Architect4r::Model::Connection
      include Architect4r::Model::Queries
      include Architect4r::Model::Relationships
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
      end
      
      attr_accessor :raw_data
      
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
      
      # Creates the document in the db. Raises an exception
      # if the document is not created properly.
      def create!(options = {})
        self.fail_validate!(self) unless self.create(options)
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
      
      def save(options = {})
        self.new? ? create(options) : update(options)
      end
      
      def save!
        self.class.fail_validate!(self) unless self.save
        true
      end
      
      def destroy
        if result = connection.delete_node(self.id)
          @_destroyed = true
          self.freeze
        end
        result
      end
      
      def id
        @id ||= if raw_data && raw_data['self'].present?
          raw_data['self'].split('/').last.to_i
        else
          nil
        end
      end
      alias :to_key :id
      alias :to_param :id
      
      def new?
        # Persisted objects always have an id.
        id.nil?
      end
      alias :new_record? :new?
      
      def destroyed?
        !!@_destroyed
      end
      
      def persisted?
        !new? && !destroyed?
      end
      
      # Update the document's attributes and save. For example:
      def update_attributes(hash)
        update_attributes_without_saving hash
        save
      end
      
      protected
      
      def perform_validations(options = {})
        (options[:validate].presence || true) ? valid? : true
      end
      
      
      class << self
        
        def create(attributes = {}, &block)
          instance = new(attributes, &block)
          instance.create
          instance
        end
        
        # Defines an instance and save it directly to the database
        def create!(attributes = {}, &block)
          instance = new(attributes, &block)
          instance.create!
          instance
        end
        
        protected
        
        # Create an object from the database data
        def build_from_database(data)
          return nil if data.blank?
          
          # Create an instance of the object
          obj = self.new(data['data'])
          obj.raw_data = data
          obj
        end
        
      end
      
    end
    
  end
  
end