class DiffChanges < AbstractCommitAnalyser
  include CommandLineHelper

  def needs_update?
    !commit.files.empty? && commit.commit_diffs.empty?
  end

  def call
    to_import = []

    command = "cd #{root_path} && git show --numstat"
    execute_command(command) do |numstat|
      numstat.split("\n").each do |row|
        if match = row.match(/^([0-9]+)\t([0-9]+)\t(.+)$/)
          added, removed, file_path = match.captures
          file = commit.select_file(file_path)

          if file
            to_import << CommitDiff.new(
              commit: commit,
              commit_file: file,
              added: added,
              removed: removed,
            )
          end
        end
      end
    end

    CommitDiff.import(to_import)
    commit.reload

    LOG.info "Found #{to_import.size} changed files"
  end
end

COMMIT_ANALYSERS << DiffChanges
