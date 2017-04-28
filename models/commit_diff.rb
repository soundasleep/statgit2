class CommitDiff < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file

  validates :added, :removed,
      presence: true,
      numericality: { only_integer: true }
end
