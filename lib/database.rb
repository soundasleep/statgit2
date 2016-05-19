require "active_record"

# Enable logging if necessary
# ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ENV['database'],
)

# Create the database if necessary
unless ActiveRecord::Base.connection.table_exists? "schema"
  require_relative "../db/schema"
end
