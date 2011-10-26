module Architect4r
  module Core
    module CypherMethods
      extend ActiveSupport::Concern
      
      module InstanceMethods
        
        def execute_cypher(query)
          
          query = self.interpolate_node_model_root_references(query)
          
          url = prepend_base_url("/ext/CypherPlugin/graphdb/execute_query")
          response = Typhoeus::Request.post(url, 
            :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' },
            :body => { 'query' => query }.to_json)
          
          # Check if there might be an error with the query
          if response.code == 400
            raise Architect4r::InvalidCypherQuery.new(query)
          elsif response.code == 500
            msg = JSON.parse(response.body)
            
            if msg['exception'].to_s.match /org.neo4j.graphdb.NotFoundException/
              nil
            else
              raise Architect4r::InvalidCypherQuery.new(query)
            end
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
        
        def interpolate_node_model_root_references(query)
          query.scan(/node\((:[^)]*_root)\)/i).flatten.uniq.each do |str|
            model_name = str.match(/^:(.*)_root$/)[1].to_s.capitalize
            if model_name.length > 0 and Object.const_defined?(model_name)
              the_model = Object.const_get(model_name)
              if the_model and the_model.respond_to?(:model_root)
                query.gsub!(str, the_model.model_root.id.to_s)
              end
            end
          end
          query
        end
        
      end
    end
  end
end