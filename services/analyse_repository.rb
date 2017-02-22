class AnalyseRepository
  include CommandLineHelper
  include DateHelper

  attr_reader :repository, :options

  def initialize(repository:, options:)
    @repository = repository
    @options = options
  end

  def call
    if options[:max].zero?
      LOG.info "Skipping Git repository analysis"
      return
    end

    LOG.info "Analysing repository..."

    # TODO fail if checked out git is not the current repository URL
    check_out_git
    export_log

    unanalysed_commits_analysed = 0

    # by default, commits are in author_date asc; we want to go author_date desc for --max
    repository.commits.reverse_order.each do |commit|
      next if options[:max].present? && unanalysed_commits_analysed >= options[:max]

      analysis = AnalyseCommit.new(commit: commit, options: options)
      if analysis.needs_update?
        nonzero_analysis = analysis.call
        unanalysed_commits_analysed += 1 if !!nonzero_analysis
      end

      if options[:max].present? && unanalysed_commits_analysed >= options[:max]
        LOG.info "Halting analysis after analysing #{unanalysed_commits_analysed} commits"
      end
    end
  end

  def commits_per_day(commits, per_day = nil)
    return commits unless per_day

    results = []
    day_map = {}
    commits.each do |commit|
      date = iso_date(commit[:author_date])

      unless day_map.has_key?(date) && day_map[date] >= per_day
        day_map[date] ||= 0
        day_map[date] += 1
        results << commit
      end
    end

    results
  end

  def commits_between(commits, from = nil, to = nil)
    hashes = commits.sort { |a, b| a[:author_date] <=> b[:author_date] }
        .map { |commit| commit[:commit_hash] }

    selected_hashes = hashes_from(hashes, from) & hashes_to(hashes, to)

    return selected_hashes.map do |hash|
      commits.find { |commit| commit[:commit_hash] == hash }
    end
  end

  def hashes_from(hashes, from = nil)
    return hashes if from.nil?

    index = hashes.find_index { |hash| hash.start_with?(from) }
    return [] if index.nil?

    return hashes.slice(index, hashes.length)
  end

  def hashes_to(hashes, to = nil)
    return hashes if to.nil?

    index = hashes.find_index { |hash| hash.start_with?(to) }
    return [] if index.nil?

    return hashes.slice(0, index + 1)
  end

  private

  def check_out_git
    if Dir.exist?(root_path)
      command = "cd #{root_path} && git remote -v"
      execute_command command do |output|
        output.split("\n").each do |line|
          remote_name, remote_url = line.split(/\s+/)
          if remote_url != repository.url
            fail "Remote '#{remote_name}' in '#{root_path}' was not '#{repository.url}': was '#{remote_url}'"
          end
        end
      end
    else
      command = "git clone #{repository.url} #{root_path}"
      execute_command command
    end

    # TODO allow specific branches to be analysed
    command = "cd #{root_path} && git reset --hard && git clean -f"
    execute_command command

    command = "cd #{root_path} && git pull origin master"
    execute_command command

    command = "cd #{root_path} && git checkout -f master"
    execute_command command
  end

  def export_log
    LOG.info "Exporting complete log..."

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

        # Use local timezone as necessary
        [:author_date, :committer_date].each do |key|
          commit[key] = DateTime.parse(commit[key]) if commit[key].is_a?(String)
          commit[key] = commit[key].in_time_zone(time_zone)
        end

        loaded_commits << commit
      end
    end

    LOG.info "Identified #{loaded_commits.size} commits in log"

    to_import = []
    commits_per_day(loaded_commits, options[:commits_per_day]).each do |commit|
      to_import << new_commit(commit)
    end

    Commit.import to_import.compact
    LOG.debug "Created #{to_import.size} commits"
  end

  def new_commit(commit)
    if Commit.where(repository: repository, commit_hash: commit[:commit_hash]).none?
      commit[:repository] = repository
      Commit.new(commit)
    else
      nil
    end
  end
end
