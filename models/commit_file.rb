class CommitFile < ActiveRecord::Base
  belongs_to :commit
  has_one :commit_diff, dependent: :destroy

  def revisions
    @revisions ||= CommitDiff.where(commit_file: self).count
  end
end
