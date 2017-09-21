require "optparse"

def default_options
  {
    limit: nil,
    max: nil,
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
  log_levels = ["debug", "info", "warn", "error", "fatal", "unknown"]
  log_levels.concat log_levels.map(&:upcase)

  OptionParser.new do |opts|
    opts.banner = "Usage: generate.rb [options]"

    opts.separator ""
    opts.separator "Specific options:"

    opts.on("-u", "--url URL", "Git repository to clone", "  If a GitHub URL, sets --blob_path and --commit_path automatically") do |url|
      options[:url] = url

      # set other paths if this is github
      if match = url.match(/^https:\/\/github.com\/([^\/]+)\/([^\/]+)\/?$/)
        username, project = match.captures

        options[:blob_path] = "https://github.com/#{username}/#{project}/blob/master/"
        options[:commit_path] = "https://github.com/#{username}/#{project}/commit/"
      end
    end

    opts.on("-w", "--workspace PATH", "Clone the Git repository to this workspace (default: `workspace/`)") do |path|
      fail "Expected / at end of workspace path" unless path[-1] == "/"
      options[:workspace] = path
    end

    opts.on("--limit COMMITS", Integer, "Only consider this number of previous commits in the log") do |commits|
      options[:limit] = commits
    end

    opts.on("--commits-per-day N", Integer, "Only consider this number of commits per day in the log") do |n|
      options[:commits_per_day] = n
    end

    opts.on("--max COMMITS", Integer, "Only analyse this many unanalysed commits (from the last [limit] commits)", "  Respects --limit and --commits-per-day settings") do |commits|
      options[:max] = commits
    end

    opts.on("--adapter ADAPTER", "Database adapter to use (default: `sqlite3`)") do |adapter|
      options[:adapter] = adapter
    end

    opts.on("--database FILE", "Database file to use (default: `:memory:`)") do |database|
      options[:database] = database
    end

    opts.separator ""
    opts.separator "Report options:"

    opts.on("-t", "--timezone ZONE", "Generate reports using this timezone (default: `UTC`)") do |timezone|
      options[:timezone] = timezone
    end

    opts.on("--commit URL", "Remote URL prefix for viewing commits with a hash (default: none)", "  Example: `https://github.com/soundasleep/statgit2/commit/`") do |commit|
      options[:commit_path] = commit
    end

    opts.on("--blob URL", "Remote URL prefix for viewing file blobs with a path (default: none)", "  Example: `https://github.com/soundasleep/statgit2/blob/master/`") do |blob|
      options[:blob_path] = blob
    end

    opts.separator ""
    opts.separator "Common options:"

    opts.on("--level LEVEL", log_levels, "Logging level severity (default: `warn`)") do |level|
      options[:level] = level.downcase
    end

    opts.on("-c", "--colours", "Use colour logging") do |c|
      options[:colours] = c
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

def options
  $command_line_options
end

unless $running_in_rspec
  load_command_line_options
  raise "Need to provide a URL with --url" unless options[:url]
end
