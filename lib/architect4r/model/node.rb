module Architect4r
  
  module Model
    
    class Node
      
      include ActiveModel::Validations
      
      include Architect4r::Model::Connection
      include Architect4r::Model::Properties
      include Architect4r::Model::Persistency
      include Architect4r::Model::Queries
      
    end
    
  end
  
end