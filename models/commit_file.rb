class CommitFile < ActiveRecord::Base
  has_many :reek_smells, dependent: :destroy

  belongs_to :commit
end
