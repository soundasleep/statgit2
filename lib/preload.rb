$LOAD_PATH << ENV['GEM_HOME'] if ENV['GEM_HOME']

puts "LOAD_PATH = #{$LOAD_PATH}"

require_relative "logger"
require_relative "database"
require_relative "templates"

ALL_REPORTS = []
COMMIT_ANALYSERS = []

include_paths = [
  "helpers",
  "models",
  "services",
  "reports",
  "analysers",
]

include_paths.each do |include_path|
  Dir[File.dirname(__FILE__) + "/../#{include_path}/abstract_*.rb"].each { |file| require file }
  Dir[File.dirname(__FILE__) + "/../#{include_path}/*.rb"].each { |file| require file }
end

