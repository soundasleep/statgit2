require_relative "database"

include_paths = [
  "models"
]

include_paths.each do |include_path|
  Dir[File.dirname(__FILE__) + "/../#{include_path}/*.rb"].each { |file| require file }
end

