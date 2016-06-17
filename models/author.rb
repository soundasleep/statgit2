class Author < ActiveRecord::Base
  belongs_to :repository

  has_many :commits, dependent: :destroy

  def changes
    @changes ||= commits.map do |commit|
      commit.commit_diffs.map do |diff|
        diff.added + diff.removed
      end.sum
    end.sum
  end

  def last_commit
    commits.last
  end
end
