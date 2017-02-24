class BlameCommit < AbstractCommitAnalyser
  include CommandLineHelper

  def needs_update?
    commit == repository.latest_commit && commit.commit_blames.empty? && !repository.authors.empty?
  end

  def call
    to_import = []

    commit.files.each do |commit_file|
      # wrap (|| true) to prevent missing but present files (e.g. in .gitignore) crashing blame
      command = "cd #{root_path} && (git blame --line-porcelain #{commit_file.full_path} || true)"
      execute_command(command) do |porcelain|
        latest_blame = nil

        # catch last commit
        porcelain += "\nfff 0"

        porcelain.split("\n").each do |row|
          if match = row.match(/^([0-9a-f]+) ([0-9 ]+)$/)
            to_import << latest_blame unless latest_blame.nil?

            commit_hash, line_stats = match.captures
            original_line, final_line, lines_in_group = line_stats.split(" ")
            referenced_commit = repository.find_commit(commit_hash)

            latest_blame = {
              commit: commit,
              commit_file: commit_file,
              line_number_in_original_file: original_line,
              line_number_in_final_file: final_line,
              lines_in_group: lines_in_group,
              referenced_commit: referenced_commit,
            }
          elsif match = row.match(/^author-mail <([^>]+)>$/)
            email = match.captures

            if latest_blame && author = repository.find_author(email)
              latest_blame[:author] = author
            end
          end
        end
      end
    end

    to_import_classes = to_import.map { |hash| CommitBlame.new(hash) }

    CommitBlame.import!(to_import_classes)

    LOG.info "Found #{to_import_classes.size} distinct commits blaming #{commit.files.size} files"

    return to_import_classes.any?
  end
end

COMMIT_ANALYSERS << BlameCommit
