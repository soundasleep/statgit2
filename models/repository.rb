class Repository < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :authors, dependent: :destroy

  def latest_commit
    commits.last
  end

  def root_path
    "workspace/"
  end

  def lines_of_code_per_day
    @lines_of_code_per_day ||= LinesOfCodePerDay.new(self).call
  end

  def commit_activity
    @commit_activity ||= CommitActivity.new(self).call
  end

  def commits_per_day
    @commits_per_day ||= CommitsPerDay.new(self).call
  end

  def commits_per_hour
    @commits_per_hour ||= CommitsPerHour.new(self).call
  end

  def commits_per_author
    @commits_per_author ||= CommitsPerAuthor.new(self).call
  end

  def latest_commit_languages
    @latest_commit_languages ||= LatestCommitLanguages.new(self).call
  end

  def files_count
    @files_count ||= FilesCount.new(self).call
  end

  def lines_of_code_per_file_per_day
    @lines_of_code_per_file_per_day ||= LinesOfCodePerFilePerDay.new(self).call
  end

  def files_with_most_revisions
    @files_with_most_revisions ||= FilesWithMostRevisions.new(self).call
  end

  def largest_files
    @largest_files ||= LargestFiles.new(self).call
  end
end
