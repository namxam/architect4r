module Architect4r
  module Core
    module ManagementMethods
      
      def get_kernel_data
        #http://localhost:7475/db/manage/server/jmx/domain/org.neo4j/
      end
      
      # Deletes the database
      def reset_database!
        
      end
      
    end
  end
end

=begin
{
  "beans" : [ {
    "description" : "Estimates of the numbers of different kinds of Neo4j primitives",
    "name" : "org.neo4j:instance=kernel#0,name=Primitive count",
    "attributes" : [ {
      "description" : "An estimation of the number of nodes used in this Neo4j instance",
      "name" : "NumberOfNodeIdsInUse",
      "value" : 109,
      "isReadable" : "true",
      "type" : "long",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "An estimation of the number of relationships used in this Neo4j instance",
      "name" : "NumberOfRelationshipIdsInUse",
      "value" : 0,
      "isReadable" : "true",
      "type" : "long",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "An estimation of the number of properties used in this Neo4j instance",
      "name" : "NumberOfPropertyIdsInUse",
      "value" : 295,
      "isReadable" : "true",
      "type" : "long",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The number of relationship types used in this Neo4j instance",
      "name" : "NumberOfRelationshipTypeIdsInUse",
      "value" : 0,
      "isReadable" : "true",
      "type" : "long",
      "isWriteable" : "false ",
      "isIs" : "false "
    } ],
    "url" : "org.neo4j/instance%3Dkernel%230%2Cname%3DPrimitive+count"
  }, {
    "description" : "Information about the Neo4j kernel",
    "name" : "org.neo4j:instance=kernel#0,name=Kernel",
    "attributes" : [ {
      "description" : "Whether this is a read only instance",
      "name" : "ReadOnly",
      "value" : false,
      "isReadable" : "true",
      "type" : "boolean",
      "isWriteable" : "false ",
      "isIs" : "true"
    }, {
      "description" : "An ObjectName that can be used as a query for getting all management beans for this Neo4j instance.",
      "name" : "MBeanQuery",
      "value" : "org.neo4j:instance=kernel#0,name=*",
      "isReadable" : "true",
      "type" : "javax.management.ObjectName",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The time from which this Neo4j instance was in operational mode.",
      "name" : "KernelStartTime",
      "value" : "Sat Sep 10 17:42:53 CEST 2011",
      "isReadable" : "true",
      "type" : "java.util.Date",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The time when this Neo4j graph store was created.",
      "name" : "StoreCreationDate",
      "value" : "Sat Sep 03 20:19:29 CEST 2011",
      "isReadable" : "true",
      "type" : "java.util.Date",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "An identifier that uniquely identifies this Neo4j graph store.",
      "name" : "StoreId",
      "value" : "a75e32d2bd11e487",
      "isReadable" : "true",
      "type" : "java.lang.String",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The current version of the Neo4j store logical log.",
      "name" : "StoreLogVersion",
      "value" : 2,
      "isReadable" : "true",
      "type" : "long",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The version of Neo4j",
      "name" : "KernelVersion",
      "value" : "Neo4j - Graph Database Kernel 1.4.1",
      "isReadable" : "true",
      "type" : "java.lang.String",
      "isWriteable" : "false ",
      "isIs" : "false "
    }, {
      "description" : "The location where the Neo4j store is located",
      "name" : "StoreDirectory",
      "value" : "/Users/namxam/packages/neo4j-community-1.4.1.test/data/graph.db",
      "isReadable" : "true",
      "type" : "java.lang.String",
      "isWriteable" : "false ",
      "isIs" : "false "
    } ],
    "url" : "org.neo4j/instance%3Dkernel%230%2Cname%3DKernel"
  } ],
  "domain" : "org.neo4j"
}
=end