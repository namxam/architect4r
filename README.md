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
      property :name, :cast_to => String, :localize => true
      property :name, :cast_to => String, :localize => :de
    end
    
    # Interfacing with the I18n class
    I18n.locale = :en
    
    # Working with a record
    instrument = Instrument.new
    instrument.name = "Piano"
    instrument.name(:de) = "Klavier"
    instrument.valid?
    instrument.save
    
    # Create associations between objects
    instrument.link_to(:category, @category_node)
    instrument.link_by(:musician, @musician_node)
    
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

_Version 0.4_

* Add node indexes
* Add relationship indexes
* Add auto indexing of class related nodes (not neo4j auto indexing)

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