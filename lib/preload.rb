$LOAD_PATH << ENV['GEM_HOME'] if ENV['GEM_HOME']

puts "LOAD_PATH = #{$LOAD_PATH}"

require_relative "logging"
require_relative "database"
require_relative "templates"
require_relative "includes"
