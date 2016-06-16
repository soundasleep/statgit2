require "logger"

# TODO only include this if the output platform supports colours
require "active_support/logger"
require "logger/colors"

LOG = Logger.new(STDOUT)
levels = {
  debug: Logger::DEBUG,
  info: Logger::INFO,
  warn: Logger::WARN,
  error: Logger::ERROR,
}
fail("Unknown log level #{options[:level]}") unless levels[options[:level].downcase.to_sym]

LOG.level = levels[options[:level].downcase.to_sym]

# Flush after every output
STDOUT.sync = true
