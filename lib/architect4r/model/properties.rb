module Architect4r
  
  module Model
    
    module Properties
      extend ActiveSupport::Concern
      
      included do
        class_attribute(:properties) unless self.respond_to?(:properties)
        self.properties ||= {}
      end
      
      def initialize(properties = {})
        super()
        
        # Init property data
        @properties_data = {}
        
        set_properties_from_hash(properties)
      end
      
      # Return a hash of all properties which can be transformed into json
      # Remove all nil values, as those cannot be stored in the graph
      def _to_database_hash
        @properties_data.merge('architect4r_type' => self.class.name).
                         reject { |key, value| value.nil? }
      end
      
      # Read the casted value of an attribute defined with a property.
      #
      # ==== Returns
      # Object:: the casted attibutes value.
      def read_attribute(property)
        @properties_data[property.to_s]
      end
      
      # Store a casted value in the current instance of an attribute defined
      # with a property and update dirty status
      def write_attribute(property, value)
        # retrieve options for the attribute
        opts = self.class.properties[property.to_s]
        
        # TODO: Mark dirty attribute tracking
        
        # Cast the value before storing it
        cast_to = opts[:cast_to] || Object
        
        @properties_data[property.to_s] = if value.nil?
          nil
        elsif cast_to == String
          value.to_s
        elsif cast_to == Integer
          value.to_i
        elsif cast_to == Float
          value.to_f
        elsif cast_to == TrueClass
          if value.kind_of?(Integer)
            value == 1
          else
            %w[ true 1 t ].include?(value.to_s.downcase)
          end
        else
          value
        end
      end
      
      def set_properties_from_hash(hash)
        return if hash.nil?
        hash.each do |key, value|
          self.send("#{key}=", value) if self.respond_to?("#{key}=")
        end
      end
      
      module ClassMethods
        
        # Allow setting properties
        def property(name, options = {})
          unless self.properties.keys.find { |p| p == name.to_s }
            define_property(name, options)
          end
        end
        
        def timestamps!
          property(:updated_at, Time, :read_only => true, :protected => true, :auto_validation => false)
          property(:created_at, Time, :read_only => true, :protected => true, :auto_validation => false)
          
          set_callback :save, :before do |object|
            write_attribute('updated_at', Time.now)
            write_attribute('created_at', Time.now) if object.new?
          end
        end
        
        protected
        
        # This is not a thread safe operation, if you have to set new properties at runtime
        # make sure a mutex is used.
        def define_property(name, options={})
          # read only flag
          read_only = options.delete(:read_only) || false
          
          # Store the property and its options
          self.properties[name.to_s] = options
          
          # Create getter and setter methods
          create_property_getter(name)
          create_property_setter(name) unless read_only == true
          
          # Return property name just in case ;)
          name
        end
        
        # defines the getter for the property (and optional aliases)
        def create_property_getter(name)
          define_method(name) do
            read_attribute(name)
          end
          
          opts = self.properties[name.to_s]
          
          if opts[:cast_to].presence && opts[:cast_to] == TrueClass
            define_method("#{name}?") do
              value = read_attribute(name)
              !(value.nil? || value == false)
            end
          end
        end
        
        # defines the setter for the property (and optional aliases)
        def create_property_setter(name)
          define_method("#{name}=") do |value|
            write_attribute(name, value)
          end
        end
        
      end
      
    end
    
  end
  
end