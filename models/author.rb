class Author < ActiveRecord::Base
  belongs_to :repository

  has_many :commits, dependent: :destroy

  def changes
    @changes ||= repository.changes_by_author(self)
  end

  def last_commit
    commits.last
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
end
