module Architect4r
  
  module Model
    
    class Node
      include Architect4r::Model::Connection
      include Architect4r::Model::Persistency
      include Architect4r::Model::Queries
      
      def self.inherited(subklass)
        super
        subklass.send(:include, Architect4r::Model::Properties)
        subklass.send(:include, Architect4r::Model::Validations)
      end
      
    end
    
  end
  
end