require 'json'
require 'typhoeus'

module Architect4r
  
  class Server
    
    class InvalidCypherQuery < SyntaxError; end
    
    # Basic rest actions
    
    def get(url, options = {})
      response = Typhoeus::Request.get(prepend_base_url(url), :headers => { 'Accept' => 'application/json' })
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def post(url, params = {})
      response = Typhoeus::Request.post(prepend_base_url(url), :params => params)
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def put(url, params = {})
      response = Typhoeus::Request.put(prepend_base_url(url), :params => params)
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def delete
      response = Typhoeus::Request.delete(prepend_base_url(url), :params => params)
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def root
      get_node(get('/')['reference_node'])
    end
    
    def create_node(properties)
      # Send request
      response = Typhoeus::Request.post(prepend_base_url('/node'), 
        :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
        :body => properties.to_json)
      
      # Evaluate response
      response.code == 201 ? JSON.parse(response.body) : nil
    end
    
    def get_node(id)
      # Handle cases where id might be a url
      url = id.to_i == 0 ? id : prepend_base_url("/node/#{id.to_i}")
      
      response = Typhoeus::Request.get(url, :headers => { 'Accept' => 'application/json' })
      response.code == 200 ? JSON.parse(response.body) : nil
    end
    
    def update_node(id, properties)
      # Handle urls
      url = id.to_i == 0 ? id : prepend_base_url("/node/#{id.to_i}")
      
      # Append the properties
      url += "/properties"
      
      response = Typhoeus::Request.put(url, 
        :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
        :body => properties.to_json)
      response.code == 204 ? true : false
    end
    
    def delete_node(id)
      # TODO: Delete all relationships
      
      # Delete node itself
      url = id.to_i == 0 ? id : prepend_base_url("/node/#{id.to_i}")
      response = Typhoeus::Request.delete(url, :headers => { 'Accept' => 'application/json' })
      response.code == 204 ? true : false
    end
    
    def execute_cypher(query)
      result_data = post("/ext/CypherPlugin/graphdb/execute_query", { 'query' => query})
      
      # Check if there might be an error with the query
      raise InvalidCypherQuery.new(query) if result_data.nil?
      
      # Convert the columnized result array to hashes within an array
      results = []
      result_data['data'].each_with_index do |row, ri|
        result_row = {}
        result_data['columns'].each_with_index do |column, ci|
          result_row[column] = convert_if_possible(row[ci])
        end
        results << result_row
      end
      results
    end
    
    protected
    
    def prepend_base_url(url)
      if url[0,4] == "http"
        url
      else
        "http://" + 'localhost' + ':' + '7475' + '' + "/db/data" + url
      end
    end
    
    def convert_if_possible(data)
      data
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