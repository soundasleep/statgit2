require "active_record"
require "connection_pool"
require "sqlite3"
require "activerecord-import"

# Enable logging if necessary
ActiveRecord::Base.logger = Logger.new(STDERR) if options[:level] == "debug"

def connect_to_database
  ActiveRecord::Base.establish_connection(
    :adapter => options[:adapter],
    :database => options[:database]
  )

  LOG.info "Using database #{options[:database]}"

  # Create the database if necessary
  unless ActiveRecord::Base.connection.table_exists? "schema"
    LOG.info "Creating database"
    require_relative "../db/schema"
  end

  # And then apply migrations as necessary
  ActiveRecord::Migrator.migrate("db/migrate/")
  LOG.info "Database migrated"
end

connect_to_database unless $running_in_rspec
