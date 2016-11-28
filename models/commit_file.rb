class CommitFile < ActiveRecord::Base
  belongs_to :commit

  has_one :commit_diff, dependent: :destroy

  has_many :file_todos, dependent: :destroy
  has_many :file_sass_stylesheets, dependent: :destroy

  def revisions
    @revisions ||= commit.repository.revisions_for(full_path)  + 1     # if a file exists, it must have had at least one commit
  end
end
