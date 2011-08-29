module Architect4r
  
  class Node
    
    # Attributes
    attr_accessor :raw_data, :data
    
    # Ids can only be read
    def id
      @id ||= raw_data['self'].present? && raw_data['self'].split('/').last.to_i || nil
    end
    
    def self.connection
      @connection ||= Server.new
    end
    
    def self.create(props)
      
    end
    
    def self.find_by_id(id)
      from_hash(connection.get("/node/#{id}"))
    end
    
    def self.root
      # We could use the find_by_id method as well, but it is much slower,
      # as we would have to parse the string in order to get the id
      from_hash(connection.get(connection.get('/')['reference_node']))
    end
    
    def self.from_hash(data={})
      # check if we really received any data, otherwise return nil
      return nil if data.blank?
      
      # Init a node from the hash
      node = Node.new
      node.raw_data = data
      node.data = data['data']
      node
    end
    
  end
  
end

=begin

  root index
    extensions: 
      CypherPlugin: 
        execute_query: http://localhost:7475/db/data/ext/CypherPlugin/graphdb/execute_query
      GremlinPlugin: 
        execute_script: http://localhost:7475/db/data/ext/GremlinPlugin/graphdb/execute_script
    relationship_types: http://localhost:7475/db/data/relationship/types
    relationship_index: http://localhost:7475/db/data/index/relationship
    reference_node: http://localhost:7475/db/data/node/0
    node: http://localhost:7475/db/data/node
    extensions_info: http://localhost:7475/db/data/ext
    node_index: http://localhost:7475/db/data/index/node


  Some random node
    extensions: {}
    
    paged_traverse: http://localhost:7475/db/data/node/0/paged/traverse/{returnType}{?pageSize,leaseTime}
    self: http://localhost:7475/db/data/node/0
    property: http://localhost:7475/db/data/node/0/properties/{key}
    data: {}
    
    incoming_typed_relationships: http://localhost:7475/db/data/node/0/relationships/in/{-list|&|types}
    outgoing_typed_relationships: http://localhost:7475/db/data/node/0/relationships/out/{-list|&|types}
    incoming_relationships: http://localhost:7475/db/data/node/0/relationships/in
    all_relationships: http://localhost:7475/db/data/node/0/relationships/all
    create_relationship: http://localhost:7475/db/data/node/0/relationships
    traverse: http://localhost:7475/db/data/node/0/traverse/{returnType}
    properties: http://localhost:7475/db/data/node/0/properties
    all_typed_relationships: http://localhost:7475/db/data/node/0/relationships/all/{-list|&|types}
    outgoing_relationships: http://localhost:7475/db/data/node/0/relationships/out
=end