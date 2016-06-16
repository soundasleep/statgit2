class CommitDiff < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file
end
