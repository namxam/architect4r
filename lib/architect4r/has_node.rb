module Architect4r
  
  # has_node :node, AccountNode, :sync => [:firstname, :lastname]
  module HasNode
    
    # Easier integration pattern
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      def has_node(attr_name, model_name, options={})
        
        #if self.respond_to?(:after_create)
          after_create :"architect4r_create_#{attr_name}"
          after_update :"architect4r_sync_#{attr_name}"
          after_destroy :"architect4r_destroy_#{attr_name}"
        #end
        
        # Create a neo4j node
        define_method("architect4r_create_#{attr_name}") do
          return nil unless self.id
          
          new_node = model_name.new
          new_node.write_attribute(:architect4r_sync_id, self.id)
          
          options[:sync].to_a.each do |prop|
            new_node.send("#{prop}=", self.send(prop))
          end
          
          if new_node.save
            new_node
          else
            nil
          end
          instance_variable_set("@#{attr_name}", new_node)
        end
        
        # Create a getter method
        define_method(attr_name) do
          # Only available if the database record is already created
          return nil unless self.id
          
          # Get or create the graph db node
          the_node = instance_variable_get("@#{attr_name}")
          the_node ||= begin
            linked_node = model_name.find_by_cypher("start s=node(#{model_name.model_root.id}) match s<-[:model_type]-d where d.architect4r_sync_id = #{self.id} return d", "d").first
            linked_node ||= self.send("architect4r_create_#{attr_name}")
            instance_variable_set("@#{attr_name}", linked_node)
          end
        end
        
        define_method("architect4r_destroy_#{attr_name}") do
          self.send("#{attr_name}").destroy
        end
        
        
        # Keep the graph node in sync, so it reflects the name
        #
        define_method("architect4r_sync_#{attr_name}") do
          changed = false
          
          options[:sync].to_a.each do |prop|
            if self.node.send("#{prop}") != self.send(prop)
              puts ">>> Changing #{prop} from #{self.node.send("#{prop}")} to #{self.send(prop)}"
              self.node.send("#{prop}=", self.send(prop))
              changed = true
            end
          end
          
          if changed
            puts ">>> Data: #{self.node.instance_variable_get(:'@properties_data').inspect}"
            self.node.save
          end
        end
        
      end
      
    end
    
  end
  
end