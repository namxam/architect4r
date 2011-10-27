# Specs

Some code which might define the future interface of the gem.
    
    # Defining
    
    class Character < Architect4r::Model::Node
      property :name, :cast_to => String
      property :human, :cast_to => TrueClass
      timestamps!
      
      def ships
        class.find_by_cypher("start s=node(#{id}) match s-[:CrewMembership]->d return d", "d")
      end
      
      def crew_memberships
        class.find_by_cypher("start s=node(#{id}) match s-[r:CrewMembership]->d return d, r", "d")
      end
    end
    
    class Ship < Architect4r::Model::Node
      property :name, :cast_to => String
    end
    
    class CrewMembership < Architect4r::Model::Relationship
      property :rank, :cast_to => String
    end
    
    neo = Character.find_by_id(15)
    neo.
    
    
    
    # Finding records
    Instrument.all
    Instrument.find_by_name("Piano")
    Instrument.find_by_name("Klavier", :de)
    Instrument.find_by_cypher("start cat=(123) match (cat)--(x) return x limit 2")
    
    # Filter associations by relationship type (:incoming, :outgoing, :all)
    instrument.links(:outgoing)
    
    # Query by model or type
    @user.links(:all, Fanship, 'studies')
    
    # Create a custom relationship
    relationship = Architect4r::Model::Relationship.create(start_node, end_note, 'CustomType', { :active => true })
    # or
    instrument.links(:incoming).create(:category, @other_node, { :created_at => DateTime.new, :active => true })
    instrument.links(:incoming).create(CategoryRelation, @other_node, { :created_at => DateTime.new, :active => true })