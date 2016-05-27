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
end
