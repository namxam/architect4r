# Release Notes

## v0.4.3.1

* Update ActiveSupport::Concern usage by removing InstanceMethods modules


## v0.4.3

* Allow retrieving multiple nodes with a single call to ```Node#find(id, id2, id3)```

## v0.4.2

* Unify the finder interface and use ```Node#find(id)``` in favor of ```Node#find_by_id(id)```

  Now nodes and relationships are using the same interface. Moreover, architect4r should be 
  more compatible with other gems (search, …).

## v0.4.1

* Allow logging of cypher queries for easier debugging

* Add proper node comparison, so we can detect multiple instances of the same node.

## v0.4

* Upgrade to neo4j 1.6 GA

  This breaks compatibility with older versions of the app, as the cypher rest interface
  has been moved to a different url.

* Add Node#all
  
  For quick inspection, added an instance method which retrieves all model records. Please 
  do not use this in production!

* Override Node#to_s to include the node id, properties and neo4j API url.

## v0.3.4.2

* Small bugfix, so the cypher_query() metod does not swallow unknown return data

## v0.3.4.1

* Make source and destination of relationships accessible

## v0.3.4

* Allow fetching items, such as nodes and relationships in one query
  
  By using the server's cypher_query() method, it is possible to fetch 
  multiple items of different types by using a single query.

## v0.3.3

* Add magic timestamp! property for tracking timestamps

  By putting timestamps! into your model, it tracks the creation date and 
  time in created\_at and updates in updated\_at

* Allow referencing model_roots in cypher queries.

  If you have a model User the reference key would be :user_root

## v0.3.2

* Support for carrierwave file upload mechanism

## v0.3.1

* Sync with ActiveModel records

  In order to use neo4j in combination with other databases, we provide a 
  small extension which allows you to keep a node in sync with another's 
  datastore record.

## v0.3

This release marks the first public release. So I wont get into length 
with its changes and new features. Let's just say it allows you to create
nodes and relationships between nodes. That's it!

* Nodes (create, update, destroy)
* Relationships (create, update, destroy)
* Querying neo4j by using cypher query language
* Callbacks and validations for nodes and relationships

## v0.2

Another internal release which was not ready for development or production.
_Please do not use it or try working with it!_ ;)

## v0.1

Some initial internal release which was very buggy and limited on the features.
