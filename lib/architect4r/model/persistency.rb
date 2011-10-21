module Architect4r
  module Model
    module Persistency
      extend ActiveSupport::Concern
      
      included do
        
      end
      
      module InstanceMethods
        
        # Creates the document in the db. Raises an exception
        # if the document is not created properly.
        def create!(options = {})
          self.fail_validate!(self) unless self.create(options)
        end
        
        def save(options = {})
          self.new? ? create(options) : update(options)
        end

        def save!
          self.class.fail_validate!(self) unless self.save
          true
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
        
      end
      
      module ClassMethods
        
        def create(*args, &block)
          instance = new(*args, &block)
          instance.create
          instance
        end
        
        # Defines an instance and save it directly to the database
        def create!(*args, &block)
          instance = new(*args, &block)
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