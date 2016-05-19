class AnalyseRepository
  include CommandLineHelper

  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def call
    LOG.info "Analysing repository..."

    check_out_git
    export_log
  end

  private

  def root_path
    "workspace/"
  end

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
    command = "cd #{root_path} && git log --reverse --format=\"#{format}\""

    execute_command(command) do |output|
      lines = output.split(end_character).map(&:strip)

      lines.reject(&:empty?).each do |line|
        line_bits = line.split(separator)
        commit = {}
        format_bits.keys.each.with_index do |key, i|
          commit[key] = line_bits[i]
        end

        new_commit commit
      end
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
