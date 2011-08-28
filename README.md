# Architect4r

Architect4r is intended as an easy ruby wrapper for the neo4j graph db 
REST API. There are other solutions such as neo4j.rb if you are working 
in a java environment or neography which provides another working wrapper 
for the REST API.

Requirements
------------

_None so far ;)_

Installation
------------

In oder to work with architect4r you have to install the gem by using 
`gem install architect4r` or in case that you are using bundler, you can 
add the following line to your _Gemfile_: `gem "architect4r"`.

Quick Start
-----------

    # Class definition
    class Instrument < Architect4r::Model
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

License
-------

Architect4r is copyright (c) 2011 Maximilian Schulz. It is free software, 
and may be redistributed under the terms of the MIT License.