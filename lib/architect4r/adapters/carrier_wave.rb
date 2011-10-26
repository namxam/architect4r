require "architect4r"
require "carrierwave"
require "carrierwave/validations/active_model"

# In order to use this class include this file in your project
# require 'architect4r/adapters/carrier_wave'
#
module Architect4r
  module Adapters
    module CarrierWave
      # Import default implementation
      include ::CarrierWave::Mount
      
      def mount_uploader(column, uploader = nil, options = {}, &block)
        property "#{column}_data", :cast_to => String
        
        # Init by calling default initializer
        super
        
        # Enable validations
        include ::CarrierWave::Validations::ActiveModel
        validates_integrity_of  column if uploader_option(column.to_sym, :validate_integrity)
        validates_processing_of column if uploader_option(column.to_sym, :validate_processing)
        
        # Add hooks
        after_save :"store_#{column}!"
        before_save :"write_#{column}_identifier"
        after_destroy :"remove_#{column}!"
        
        # These hooks cannot be used until dirty tracking is implemented
        #before_update :"store_previous_model_for_#{column}"
        #after_save :"remove_previously_stored_#{column}"
        
        class_eval <<-RUBY, __FILE__, __LINE__+1
          
          public
          
          def read_uploader(column)
            self.send("#{column}_data")
          end
          
          def write_uploader(column, identifier)
            self.send("#{column}_data=", identifier)
          end
          
        RUBY
      end
      
    end
  end
end

# Add this to all nodes and relationships (funky isn't it?)
module Architect4r
  module Model
    class Node
      extend Architect4r::Adapters::CarrierWave
    end
    
    class Relationship
      extend Architect4r::Adapters::CarrierWave
    end
  end
end