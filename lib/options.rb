require "optparse"

def load_command_line_options
  options = {
    limit: nil,
    commits_per_day: nil,
    adapter: "sqlite3",
    database: ":memory:",
    debug: false,
    url: nil,
    timezone: nil,
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: generate.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:debug] = v
    end

    opts.on("-u", "--url URL", "Analyse this Git repository") do |url|
      options[:url] = url
    end

    opts.on("-t", "--timezone ZONE", "Generate reports using this timezone (default: local)") do |timezone|
      options[:timezone] = timezone
    end

    opts.on("--limit COMMITS", Integer, "Only go back this number of commits") do |commits|
      options[:limit] = commits
    end

    opts.on("--commits-per-day N", Integer, "Select the most recent N commits per day") do |n|
      options[:commits_per_day] = n
    end

    opts.on("--adapter ADAPTER", "Database adapter to use (default: `sqlite3`)") do |adapter|
      options[:adapter] = adapter
    end

    opts.on("--database FILE", "Database file to use (default: `:memory:`)") do |database|
      options[:database] = database
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

    opts.on_tail("--version", "Show version") do
      puts ::Version.join(".")
      exit
    end
  end.parse!

  $command_line_options = options
end

load_command_line_options

def options
  $command_line_options
end
