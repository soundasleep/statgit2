class AnalyseRepository
  include CommandLineHelper
  include DateHelper

  attr_reader :repository, :options

  def initialize(repository:, options:)
    @repository = repository
    @options = options
  end

  def call
    LOG.info "Analysing repository..."

    # TODO fail if checked out git is not the current repository URL
    check_out_git
    export_log

    repository.commits.each do |commit|
      AnalyseCommit.new(commit: commit, options: options).call
    end
  end

  def commits_per_day(commits, per_day = nil)
    return commits unless per_day

    results = []
    day_map = {}
    commits.each do |commit|
      date = iso_date(Date.parse(commit[:author_date]))

      unless day_map.has_key?(date) && day_map[date] >= per_day
        day_map[date] ||= 0
        day_map[date] += 1
        results << commit
      end
    end

    results
  end

  private

  def check_out_git
    unless Dir.exist?(root_path)
      command = "git clone #{repository.url} #{root_path}"
      execute_command command
    end

    command = "cd #{root_path} && git pull origin master"
    execute_command command
  end

  def export_log
    LOG.info "Exporting complete log to JSON..."

    separator = "(separator)"
    end_character = "(end log entry)"

    format_bits = {
      commit_hash: "%H",
      short_hash: "%h",
      tree_hash: "%T",
      parent_hashes: "%P",
      author_name: "%an",
      author_email: "%ae",
      author_date: "%ai",
      committer_name: "%cn",
      committer_email: "%ce",
      committer_date: "%ci",
      subject: "%s",
      body: "%b",
      commit_notes: "%N",
    }

    format = format_bits.values.join(separator) + end_character
    limit = options[:limit] ? "-#{options[:limit]} " : ""
    command = "cd #{root_path} && git log #{limit} --reverse --format=\"#{format}\""

    loaded_commits = []

    execute_command(command) do |output|
      lines = output.split(end_character).map(&:strip)

      lines.reject(&:empty?).each do |line|
        line_bits = line.split(separator)
        commit = {}
        format_bits.keys.each.with_index do |key, i|
          commit[key] = line_bits[i]
        end

        loaded_commits << commit
      end
    end

    commits_per_day(loaded_commits, options[:commits_per_day]).each do |commit|
      new_commit commit
    end
  end

  def new_commit(commit)
    if Commit.where(repository: repository, commit_hash: commit[:commit_hash]).none?
      commit[:repository] = repository
      c = Commit.create! commit
      LOG.debug "Created commit #{c.id}"
    end
  end
end
