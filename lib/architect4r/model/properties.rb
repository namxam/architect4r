module Architect4r
  
  module Model
    
    module Properties
      extend ActiveSupport::Concern
      
      included do
        class_attribute(:properties) unless respond_to?(:properties)
        self.properties ||= {}
      end
      
      module InstanceMethods
        def parse_properties(properties = {})
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
        def read_attribute(property, locale = nil)
          property = "#{property}_#{locale}" if locale
          @properties_data[property.to_s]
        end

        # Store a casted value in the current instance of an attribute defined
        # with a property and update dirty status
        def write_attribute(property, value, locale = nil)
          # retrieve options for the attribute
          opts = self.class.properties[property.to_s]
          
          # Check if we should store a localized version of the data
          property = "#{property}_#{locale}" if locale
          
          # TODO: Mark dirty attribute tracking
          
          # Cast the value before storing it
          cast_to = opts && opts[:cast_to] || Object
          
          @properties_data[property.to_s] = if value.nil?
            nil
          elsif cast_to == String
            value.to_s
          elsif cast_to == Integer
            value.to_i
          elsif cast_to == Float
            value.to_f
          elsif cast_to == TrueClass or cast_to == FalseClass
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
            if self.respond_to?("#{key}=")
              self.send("#{key}=", value)
            else
              @properties_data[key] = value
            end
          end
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
          property(:updated_at, :cast_to => Time)
          property(:created_at, :cast_to => Time)
          
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
            # Get property configuration
            localize = self.class.properties[name.to_s][:localize]
            
            # Determine current locale
            locale = localize ? I18n.locale : nil
            
            # Fetch property value
            result = read_attribute(name, locale)
            
            # If there is a fallback locale, fetch its value if appropriate
            if result.nil? && localize && localize != true && localize.to_s != locale.to_s
              result = read_attribute(name, localize)
            end
            
            # Finally return some data
            result
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
            locale = self.class.properties[name.to_s][:localize] ? I18n.locale : nil
            write_attribute(name, value, locale)
          end
        end
        
      end
      
    end
    
  end
  
end