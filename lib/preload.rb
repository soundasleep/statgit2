$LOAD_PATH << ENV['GEM_HOME'] if ENV['GEM_HOME']

require_relative "options"
require_relative "logging"
require_relative "database"
require_relative "templates"
require_relative "includes"
