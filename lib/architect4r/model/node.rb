module Architect4r
  
  module Model
    
    class Node
      
      #
      # architect4r extensions
      #
      include Architect4r::Model::Connection
      include Architect4r::Model::Callbacks
      include Architect4r::Model::Persistency
      include Architect4r::Model::Queries
      include Architect4r::Model::Relationships
      
      def self.inherited(subklass)
        super
        subklass.send(:include, ActiveModel::Conversion)
        subklass.extend ActiveModel::Naming
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
        
        subklass.class_exec do
          
          def self.model_root
            @model_root ||= begin
              # Check if there is already a model root,
              query = "start root = node(0) match (root)-[r:#{model_root_relation_type}]->(x) where r.architect4r_type and r.architect4r_type = '#{name}' return x"
              the_root = connection.execute_cypher(query).to_a.flatten.first
              the_root &&= the_root['x']
              
              # otherwise create one
              the_root ||= begin 
                m_root = connection.create_node(:name => "#{name} Root")
                connection.create_relationship(0, m_root, model_root_relation_type, { 'architect4r_type' => name })
                m_root
              end
              
              # Return model root node
              GenericNode.send(:build_from_database, the_root)
            end
          end
          
        end
      end
      
      attr_accessor :raw_data
      
      def initialize(properties={})
        run_callbacks :initialize do
          parse_properties(properties)
        end
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
            if result = connection.create_node(self._to_database_hash)
              self.raw_data = result
          
              # Link the node with a model root node
              connection.create_relationship(self.id, self.class.model_root.id, 'model_type')
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
            result = connection.update_node(self.id, self._to_database_hash)
        
            # if something goes wrong we receive a nil value and return false
            !result.nil?
          end
        end
      end
      
      def destroy
        run_callbacks :destroy do
          if result = connection.delete_node(self.id)
            @_destroyed = true
            self.freeze
          end
          result
        end
      end
      
      def self.model_root_relation_type
        'model_root'
      end
      
    end
    
  end
  
end