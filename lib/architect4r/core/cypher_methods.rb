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
            JSON.parse(response.body)
          end
        end
        
        # Convert the columnized result array to a hashes within an array
        #
        # The input would look like:
        #
        # { 'data' => [['r1', 'n1'], ['r2', 'n2'], …], 'columns' => ['rel', 'node']}
        # 
        # And it would be transformed to:
        # [ { 'rel' => 'r1', 'node' => 'n1' }, { 'rel' => 'r2', 'node' => 'n2' } ]
        #
        def transform_cypher_result_to_hash(input)
          results = []
          input['data'].each_with_index do |row, ri|
            result_row = {}
            input['columns'].each_with_index do |column, ci|
              result_row[column] = row[ci]
            end
            results << result_row
          end
          results
        end
        
        # Parses a cypher query and replaces all placeholders for model roots 
        # with the neo4j ids. It should make development faster, as you can 
        # skip manual id retrieval:
        #
        # So instead of writing:
        #
        #     "start s=node(#{Person.model_root.id}) match s-->d return d"
        # 
        # you can write:
        # 
        #     "start s=node(:person_root) match s-->d return d"
        #
        def interpolate_node_model_root_references(query)
          query.scan(/node\((:[^)]*_root)\)/i).flatten.uniq.each do |str|
            model_name = str.match(/^:(.*)_root$/)[1].to_s.classify
            if model_name.length > 0
              # As const_defined? and const_get to not support namespaces, we have to use eval :(
              begin
                query.gsub!(str, eval("#{model_name}.model_root.id.to_s"))
              rescue NoMethodError => ex
                nil
              end
            end
          end
          query
        end
        
      end
    end
  end
end