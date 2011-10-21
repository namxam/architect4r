module Architect4r
  module Core
    module CypherMethods
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
        def execute_cypher(query)
          url = prepend_base_url("/ext/CypherPlugin/graphdb/execute_query")
          response = Typhoeus::Request.post(url, 
            :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
            :body => { 'query' => query }.to_json)
          
          # Check if there might be an error with the query
          if response.code == 500
            raise Architect4r::InvalidCypherQuery.new(query)
          elsif response.code == 204
            nil
          else
            result_data = JSON.parse(response.body)
            
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
        end
        
      end
    end
  end
end