require "optparse"

def default_options
  {
    limit: nil,
    commits_per_day: nil,
    adapter: "sqlite3",
    database: ":memory:",
    timezone: "UTC",
    level: "info",
    colours: false,
    blob_path: nil,
    commit_path: nil,
    workspace: "workspace/",
  }
end

def load_command_line_options
  options = default_options

  OptionParser.new do |opts|
    opts.banner = "Usage: generate.rb [options]"

    opts.on("-c", "--colours", "Use colour logging") do |c|
      options[:colours] = c
    end

    opts.on("-u", "--url URL", "Analyse this Git repository") do |url|
      options[:url] = url

      # set other paths if this is github
      if match = url.match(/^https:\/\/github.com\/([^\/]+)\/([^\/]+)\/?$/)
        username, project = match.captures

        options[:blob_path] = "https://github.com/#{username}/#{project}/blob/master/"
        options[:commit_path] = "https://github.com/#{username}/#{project}/commit/"
      end
    end

    opts.on("-t", "--timezone ZONE", "Generate reports using this timezone (default: `UTC`)") do |timezone|
      options[:timezone] = timezone
    end

    opts.on("-w", "--workspace PATH", "Use this path as the Git workspace (default: `workspace/`)") do |path|
      fail "Expected / at end of path" unless path[-1] == "/"
      options[:workspace] = path
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

    opts.on("--level LEVEL", "Log to this level (default: `warn`)") do |level|
      options[:level] = level.downcase
    end

    opts.on("--blob URL", "Use this URL as a prefix to view file blobs (default: none)") do |blob|
      options[:blob_path] = blob
    end

    opts.on("--commit URL", "Use this URL as a prefix to view individual commits (default: none)") do |commit|
      options[:commit_path] = commit
    end

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end

    opts.on_tail("--version", "Show version") do
      puts ::Version.join(".")
      exit
    end
  end.parse

  $command_line_options = options
end

load_command_line_options

def options
  $command_line_options
end
