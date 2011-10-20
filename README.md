# Architect4r

Architect4r is intended as an easy ruby wrapper for the neo4j graph db 
REST API. There are other solutions such as neo4j.rb if you are working 
in a java environment or neography which provides another working wrapper 
for the REST API.

Requirements
------------

You need a running neo4j installation.

Installation
------------

In oder to work with architect4r you have to install the gem by using 
`gem install architect4r` or in case that you are using bundler, you can 
add the following line to your _Gemfile_: `gem "architect4r"`.

Quick Start
-----------

    # Class definition
    class Instrument < Architect4r::Model
      # Properties
      property :name, :cast_to => String, :localize => true
      property :name, :cast_to => String, :localize => :de
      
      # Validations
      validates :name, :presence => true
    end
    
    # Interfacing with the I18n class
    I18n.locale = :en
    
    # Working with a record
    instrument = Instrument.new
    instrument.name = "Piano"
    instrument.name(:de) = "Klavier"
    instrument.valid?
    instrument.save
    
    # Associations between objects
    instrument.links.outgoing
    instrument.links.incoming
    instrument.links.both
    
    # Filter associations by relationship type (incoming, outcoming, both)
    instrument.links.outgoing(:category, :fan)
    
    
    class Fanship < Architect4r::Model::Relationship
      # All relationships need a unique descriptor
      descriptor 'fanship' # if not set it is derived from the class name
      
      # Properties
      property :created_at, :cast_to => DateTime
      property :reason, :cast_to => String
    end
    
    # Init a class based relationship
    Fanship.new( :start_node => @user,
                 :end_node => @instrument,
                 :created_at => DateTime.new, 
                 :reason => 'Because I like you')
    
    # Query by type
    @user.links.outgoing(Fanship)
    
    
    
    # Create a complex relationships
    relationship = instrument.links.incoming.new
    relationship.save
    # or
    instrument.links.incoming.create(:category, @other_node, { :created_at => DateTime.new, :active => true })
    instrument.links.incoming.create(CategoryRelation, @other_node, { :created_at => DateTime.new, :active => true })
    
    
    # Updating attributes
    instrument.update_attributes(params[:instrument])
    
    # Finding records
    Instrument.all
    Instrument.find_by_id(123)
    Instrument.find_by_name("Piano")
    Instrument.find_by_name("Klavier", :de)
    Instrument.find_by_cypher("start cat=(123) match (cat)--(x) return x limit 2")

Roadmap / Next Steps
--------------------

_Version 0.3_

* Add relationships
* Auto add class related nodes to a class root node for easy queries

_Version 0.4_

* Add node indexes
* Add relationship indexes
* Add auto indexing of node properties / nodes (not neo4j auto indexing)

_Version 0.5_

* Add more node finders by using indexes

_Version 0.6_

* Create a ORM (ActiveRecord) synced node

_Version 0.7_

* Give the cypher plugin some more love
* Add more default queries

_Version 0.8_

* Rake tasks for installing neo4j
* Rake tasks for test setup

_Version 0.9_

* Make it compatible to paperclip and carrierwave
* Make it compatible to sunspot search
* Add basic authentication
* Add digest authentication

_Version 1.0_

* Improve test case
* Optimize, optimize, optimize

_sometime in the future_

* Allow batch execution by facilitating hydra's concurrency model

License
-------

Architect4r is copyright (c) 2011 Maximilian Schulz. It is free software, 
and may be redistributed under the terms of the MIT License.