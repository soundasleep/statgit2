require "active_record"
require "connection_pool"
require "sqlite3"

# Enable logging if necessary
ActiveRecord::Base.logger = Logger.new(STDERR) if options[:debug]

unless $running_in_rspec
  ActiveRecord::Base.establish_connection(
    :adapter => options[:adapter],
    :database => options[:database]
  )

  LOG.info "Using database #{options[:database]}"

  # Create the database if necessary
  unless ActiveRecord::Base.connection.table_exists? "schema"
    require_relative "../db/schema"
  end
end
