require 'json'
require 'typhoeus'

module Architect4r
  
  class Server
    
    class InvalidCypherQuery < SyntaxError; end
    
    include Architect4r::Core::CypherMethods
    include Architect4r::Core::NodeMethods
    
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

  Example service root response
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
=end