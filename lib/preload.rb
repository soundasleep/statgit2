require_relative "logger"
require_relative "database"
require_relative "templates"

ALL_REPORTS = []

include_paths = [
  "helpers",
  "models",
  "services",
  "reports",
]

include_paths.each do |include_path|
  Dir[File.dirname(__FILE__) + "/../#{include_path}/*.rb"].each { |file| require file }
end

