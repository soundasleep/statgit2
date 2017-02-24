class CommitBlame < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file

  belongs_to :author
  belongs_to :referenced_commit, class_name: "Commit"
end
