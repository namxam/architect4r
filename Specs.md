# Specs

Some code which might define the future interface of the gem.
    
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