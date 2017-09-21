class Author < ActiveRecord::Base
  include AnalysedCommits

  belongs_to :repository

  has_many :commits, dependent: :destroy
  has_many :git_blames, dependent: :destroy

  validates :name, presence: true

  def changes
    @changes ||= repository.changes_by_author(self)
  end

  def last_commit
    commits.last
  end

  def most_owned_files
    @most_owned_files ||= MostOwnedFiles.new(self).call
  end
end
