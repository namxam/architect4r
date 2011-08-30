module Architect4r
  module Core
    module CypherMethods
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
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
        
      end
    end
  end
end