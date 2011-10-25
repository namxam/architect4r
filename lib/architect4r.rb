#
# Gem management
#
require 'architect4r/version'

#
# Extensions
#
require 'active_model'
require 'active_support'
require 'active_support/core_ext'
#require 'architect4r/extensions/object'

#
# Core modules
#
require 'architect4r/core/configuration'
require 'architect4r/core/cypher_methods'
require 'architect4r/core/node_methods'
require 'architect4r/core/relationship_methods'

#
# Basic server interaction
#
require 'architect4r/server'

#
# Model features
#
require 'architect4r/model/connection'
require 'architect4r/model/properties'
require 'architect4r/model/persistency'
require 'architect4r/model/queries'
require 'architect4r/model/validations'
require 'architect4r/model/callbacks'
require 'architect4r/model/links_query_interface'
require 'architect4r/model/relationships'
require 'architect4r/model/node'
require 'architect4r/model/relationship'

#
# Generic items
#
require 'architect4r/generic_node'

#
# Support for multi database environments
#
require 'architect4r/has_node'
# Auto load the extension when active record is used
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:include, Architect4r::HasNode)
end

#
# The namespace
#
module Architect4r
  
  def self.version
    "Architect4r version #{Architect4r::VERSION}"
  end
  
  class InvalidCypherQuery < SyntaxError; end
  
end