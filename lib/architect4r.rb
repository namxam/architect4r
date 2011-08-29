#
# Gem management
#
require 'architect4r/version'

#
# Extensions
#
require 'architect4r/extensions/object'

#
# Basic server interaction
#
require 'architect4r/server'
require 'architect4r/node'

#
# Model features
#
# none so far


#
# The namespace
#
module Architect4r
  
  def self.version
    "Architect4r version #{Architect4r::VERSION}"
  end
  
end