module Architect4r
  module Core
    module RelationshipMethods
      extend ActiveSupport::Concern
      
      def create_relationship(start_node, end_node, type, properties={})
        # POST http://localhost:7474/db/data/node/3/relationships
        # {"to" : "http://localhost:7474/db/data/node/4", "type" : "LOVES"}
        # 201: Created
        # Location: http://localhost:7474/db/data/relationship/2
        
        # Add the destination node and type to the properties
        properties = { 'to' => node_url(end_node), 'type' => type.to_s, 'data' => properties }
        
        # Send request
        response = Typhoeus::Request.post(node_url(start_node) + "/relationships", 
          :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          :body => properties.to_json)
        
        # Evaluate response
        response.code == 201 ? JSON.parse(response.body) : nil
      end
      
      def get_relationship(relationship)
        response = Typhoeus::Request.get(relationship_url(relationship), :headers => { 'Accept' => 'application/json' })
        response.code == 200 ? JSON.parse(response.body) : nil
      end
      
      def delete_relationship(relationship)
        response = Typhoeus::Request.delete(relationship_url(relationship), :headers => { 'Accept' => 'application/json' })
        response.code == 204 ? true : false
      end
      
      def get_node_relationships(node, direction = :all, *types)
        # GET http://localhost:7474/db/data/node/6/relationships/all
        # GET http://localhost:7474/db/data/node/11/relationships/in
        # GET http://localhost:7474/db/data/node/16/relationships/out
        # GET http://localhost:7474/db/data/node/21/relationships/all/LIKES&HATES
        # 200: OK
        
        # Set direction
        direction = case direction.to_s
          when 'incoming'
            'in'
          when 'outgoing'
            'out'
          else
            'all'
        end
        
        # Create typ filter
        types = types.map { |e| URI.escape(e) }.join('&')
        
        # Send request
        url = node_url(node) + "/relationships/#{direction}/#{types}"
        response = Typhoeus::Request.get(url, :headers => { 'Accept' => 'application/json' })
        response.code == 200 ? JSON.parse(response.body) : []
      end
      
      def update_relationship(id, properties)
        # PUT http://localhost:7474/db/data/relationship/0/properties
        # 204: No Content
        url = relationship_url(id) + '/properties'
        response = Typhoeus::Request.put(url, 
          :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
          :body => properties.to_json)
        response.code == 204 ? true : false
      end
      
      def get_relationship_types
        # GET http://localhost:7474/db/data/relationship/types
        # 200: OK
        response = Typhoeus::Request.get(prepend_base_url('/relationship/types'), :headers => { 'Accept' => 'application/json' })
        response.code == 200 ? JSON.parse(response.body) : []
      end
      
    end
  end
end