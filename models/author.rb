class Author < ActiveRecord::Base
  belongs_to :repository

  has_many :commits, dependent: :destroy

  def changes
    @changes ||= repository.changes_by_author(self)
  end

  def last_commit
    commits.last
  end
end
