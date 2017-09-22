require "logger"
require "active_support/logger"

LOG = Logger.new(STDOUT)

unless $running_in_rspec
  if options[:colours]
    require "logger/colors"
  end

  levels = {
    debug: Logger::DEBUG,
    info: Logger::INFO,
    warn: Logger::WARN,
    error: Logger::ERROR,
  }
  fail("Unknown log level #{options[:level]}") unless levels[options[:level].to_sym]

  LOG.level = levels[options[:level].to_sym]
end

# Flush after every output
STDOUT.sync = true
