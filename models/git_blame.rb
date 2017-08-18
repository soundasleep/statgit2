class GitBlame < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file
  belongs_to :author

  validates :line_count,
      presence: true,
      numericality: { only_integer: true }
end
