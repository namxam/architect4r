module Architect4r
  module Model
    class Relationship
      
      include Architect4r::Model::Connection
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
      end
      
      attr_accessor :source, :destination
      
      def initialize(*args)
        # Detect source and destination
        if s = args[0].is_a?(Architect4r::Model::Node) && args.shift
          self.source = s
          
          if d = args[0].is_a?(Architect4r::Model::Node) && args.shift
            self.destination = d
          end
        end
        
        # Detect properties
        if properties = args[0].is_a?(Hash) && args.shift
          parse_properties(properties)
        end
      end
      
    end
  end
end