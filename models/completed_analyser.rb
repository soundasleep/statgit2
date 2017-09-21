class CompletedAnalyser < ActiveRecord::Base
  belongs_to :commit

  validates :class_name, presence: true
end
