ALL_REPORTS = []
COMMIT_ANALYSERS = []
FILE_ANALYSERS = []

include_paths = [
  "helpers",
  "models",
  "services",
  "reports",
  "analysers",
  "analysers/file_readers",
  "transforms",
]

include_paths.each do |include_path|
  Dir[File.dirname(__FILE__) + "/../#{include_path}/abstract_*.rb"].each { |file| require file }
  Dir[File.dirname(__FILE__) + "/../#{include_path}/*.rb"].each { |file| require file }
end

