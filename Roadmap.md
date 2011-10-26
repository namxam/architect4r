# Roadmap

_Check the release notes for info on previous versions_


There is no real roadmap for architect4r, as this project is only used in 
a single project so far. If there is anything you miss, either fork the 
project, implement the feature and send a pull request, or submit an issue.

The following items are kinda planned to be integrated in the future:

* Give the cypher plugin some more love
* Add more default queries
* Add tracking of dirty attributes
* Make it compatible to file uploaders such as paperclip and carrierwave
* Make it compatible to search engines such as sunspot, elastic search, sphinx, …
* Rake tasks for installing neo4j
* Rake tasks for test setup
* Versioning of nodes (update node but create a linked node with the old properties)
* Improve documentation
* Improve test cases

And there are a few features which might be integrated, but are not yet really planned:

* Accessible relationships as you know it from active record
* Support for indexes (nodes and relations)
* Add more finders by using indexes
* Add auto indexing of node properties / nodes (not neo4j auto indexing)
* Add basic authentication
* Add digest authentication
* Facilitate hydra's concurrency model