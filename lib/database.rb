require "active_record"
require "connection_pool"
require "sqlite3"

ENV['DATABASE'] ||= ":memory:"

# Enable logging if necessary
ActiveRecord::Base.logger = Logger.new(STDERR) if ENV['DEBUG']

unless $running_in_rspec
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => ENV['DATABASE'],
  )

  LOG.info "Using database #{ENV['DATABASE']}"

  # Create the database if necessary
  unless ActiveRecord::Base.connection.table_exists? "schema"
    require_relative "../db/schema"
  end
end
