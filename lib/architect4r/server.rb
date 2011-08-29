require 'json'
require 'typhoeus'

module Architect4r
  
  class Server
    
    class InvalidCypherQuery < SyntaxError; end
    
    def get(url)
      response = Typhoeus::Request.get(prepend_base_url(url))
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def post(url, params)
      response = Typhoeus::Request.post(prepend_base_url(url), :params => params)
      response.success? ? JSON.parse(response.body) : nil
    end
    
    def put
      
    end
    
    def delete
      
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