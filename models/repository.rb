class Repository < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :authors, dependent: :destroy

  def latest_commit
    commits.last
  end
end
