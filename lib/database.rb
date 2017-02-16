require "active_record"
require "connection_pool"
require "sqlite3"
require "activerecord-import"

def connect_to_database(options)
  ActiveRecord::Base.remove_connection

  ActiveRecord::Base.establish_connection(
    :adapter => options[:adapter],
    :database => options[:database]
  )

  LOG.info "Using database #{options[:database]}"

  # And then apply migrations as necessary
  ActiveRecord::Migrator.migrate("db/migrate/")
  LOG.info "Database migrated"
end

unless $running_in_rspec
  # Enable logging if necessary
  ActiveRecord::Base.logger = Logger.new(STDERR) if options[:level] == "debug"

  connect_to_database(options) unless $running_in_rspec
end
