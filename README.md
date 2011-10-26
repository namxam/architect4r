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
    class Instrument < Architect4r::Model::Node
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
    
    # Updating attributes
    instrument.update_attributes(params[:instrument])
    
    # Finding records
    Instrument.find_by_id(123)
    
    class Fanship < Architect4r::Model::Relationship
      # Properties
      property :created_at, :cast_to => DateTime
      property :reason, :cast_to => String
    end
    
    # Init a class based relationship
    Fanship.new(@user, @instrument, { :reason => 'Because I like you' })

License
-------

Architect4r is copyright (c) 2011 Maximilian Schulz. It is free software, 
and may be redistributed under the terms of the MIT License.