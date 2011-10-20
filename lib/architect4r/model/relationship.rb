module Architect4r
  module Model
    class Relationship
      
      include Architect4r::Model::Connection
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
      end
      
    end
  end
end