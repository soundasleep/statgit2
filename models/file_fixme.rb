class FileFixme < ActiveRecord::Base
  belongs_to :commit
  belongs_to :commit_file

  validates :fixme_count, presence: true, numericality: { only_integer: true }
end
