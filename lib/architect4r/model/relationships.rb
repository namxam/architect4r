module Architect4r
  module Model
    module Relationships
      extend ActiveSupport::Concern
      
      def links
        @links_query_interface = LinksQueryInterface.new(self)
      end
      
    end
  end
end