require 'json'
require 'typhoeus'

module Architect4r
  
  class Server
    
    include Architect4r::Core::CypherMethods
    include Architect4r::Core::NodeMethods
    include Architect4r::Core::RelationshipMethods
    
    def initialize(config=nil)
      @server_config = config
    end
    
    def configuration
      @configuration ||= Core::Configuration.new(@server_config)
    end
    
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
    
    def node_url(url_or_id)
      if url_or_id.is_a?(Hash)
        url_or_id['self'].to_s
      elsif url_or_id.to_s != '0' and url_or_id.to_i == 0
        url_or_id.to_s
      else
        prepend_base_url("/node/#{url_or_id.to_i}")
      end
    end
    
    def relationship_url(url_or_id)
      if url_or_id.is_a?(Hash)
        url_or_id['self'].to_s
      elsif url_or_id.to_s != '0' and url_or_id.to_i == 0
        url_or_id.to_s
      else
        prepend_base_url("/relationship/#{url_or_id.to_i}")
      end
    end
    
    # Build a node or relationship from the hash neo4j returns.
    def convert_if_possible(object_hash)
      if klass = object_hash.is_a?(Hash) && object_hash['data']
        if model_string = object_hash['data']['architect4r_type']
          data = begin
            eval("#{model_string}.send(:build_from_database, object_hash)")
          rescue => ex
            data
          end
        elsif object_hash['self'].match(/node\/\d+$/i)
          data = GenericNode.send(:build_from_database, object_hash)
        end
      else
        data = object_hash
      end
      data
    end
    
    
    protected
    
    def prepend_base_url(url)
      if url[0,4] == "http"
        url
      else
        "http://#{configuration.host}:#{configuration.port}#{configuration.path}/db/data#{url}"
      end
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