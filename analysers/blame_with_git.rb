class BlameWithGit < AbstractCommitAnalyser
  include CommandLineHelper

  class GitBlameError < StandardError; end

  def needs_update?
    commit == repository.latest_commit &&
      repository.latest_commit.commit_files.any? &&
      repository.latest_commit.git_blames.empty?
  end

  def call
    to_import = []
    i = 0

    repository.latest_commit.commit_files.each do |commit_file|
      i += 1
      next if binary_file?(commit_file.full_path)

      LOG.info "Blaming #{commit_file.full_path} (#{percent_done(i)})..." if i % 100 == 0

      command = "cd #{root_path} && git blame --line-porcelain \"#{commit_file.full_path}\""
      blame_authors = {}

      stream_command(command) do |line|
        bits = line.split(" ", 2)
        if bits[0] == "author-mail"
          # drop <> around email
          mail = bits[1][1..(bits[1].length - 2)]

          if !blame_authors.has_key?(mail)
            if author = find_author(mail)
              blame_authors[mail] = GitBlame.new(
                commit: commit,
                commit_file: commit_file,
                author: author,
                line_count: 0,
              )
            else
              LOG.debug "Could not find author for mail '#{mail}'"
            end
          end

          if blame_authors[mail]
            blame_authors[mail].line_count += 1
          end
        end
      end

      to_import += blame_authors.values
    end

    raise GitBlameError, "Expected at least one git blame" if to_import.empty?
    GitBlame.import!(to_import)

    LOG.info "Found #{to_import.size} Git blames over #{repository.latest_commit.commit_files.length} files"

    delete_old_git_blames!

    return to_import.any?
  end

  private

  def delete_old_git_blames!
    # Delete any GitBlames that exist for any other Commit - we don't
    # calculate blames for any other commit, so any older data wouldn't
    # be valid anyway.

    # (This should make it simpler to do author.git_blames without
    # also needing to reject commits that aren't the latest commit.)

    # TODO this could be MUCH faster if you did instead,
    # DELETE FROM git_blames WHERE commit_id IN (SELECT id FROM commits WHERE repository = ? AND id != ?)
    repository.commits.each do |commit|
      if commit != repository.latest_commit
        commit.git_blames.delete_all
      end
    end

    LOG.info "Deleted Git blames for older revisions"
  end

  def find_author(mail)
    @find_author ||= Hash.new do |hash, key|
      hash[key] = repository.authors.where(email: key).first

      # Some old authors may not be registered as having a commit within
      # the last --max or --limit commits
      if !hash[key]
        hash[key] = repository.authors.create!(name: key, email: key)
      end
    end
    @find_author[mail]
  end

  def percent_done(i)
    sprintf "%0.1f%%", (i / repository.latest_commit.commit_files.count.to_f) * 100
  end
end

COMMIT_ANALYSERS << BlameWithGit
