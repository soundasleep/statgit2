$LOAD_PATH << ENV['GEM_HOME'] if ENV['GEM_HOME']

require "active_support"

ActiveSupport::Dependencies.autoload_paths = [
  "lib/",
  "helpers/",
  "models/modules/",
  "models/",
  "services/",
  "reports/",
  "analysers/",
  "analysers/file_readers/",
  "transforms/",
]

require_relative "options"
require_relative "logging"
require_relative "database"
