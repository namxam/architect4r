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
require 'architect4r/core/node_methods'
require 'architect4r/core/cypher_methods'

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
require 'architect4r/model/node'


#
# The namespace
#
module Architect4r
  
  def self.version
    "Architect4r version #{Architect4r::VERSION}"
  end
  
end