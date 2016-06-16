require "logger"

require "active_support/logger"

if options[:colours]
  require "logger/colors"
end

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
