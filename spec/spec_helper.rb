$running_in_rspec = true

require "rspec"
require "rspec/collection_matchers"

require File.join(File.dirname(__FILE__), "..", "lib", "preload")
LOG.level = Logger::WARN

require File.join(File.dirname(__FILE__), "integration", "integration_spec_support")
