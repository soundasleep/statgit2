class LinesOfCodeStat < ActiveRecord::Base
  belongs_to :commit

  validates :language, presence: true
  validates :files, presence: true, numericality: { only_integer: true }
  validates :blank, presence: true, numericality: { only_integer: true }
  validates :comment, presence: true, numericality: { only_integer: true }
  validates :code, presence: true, numericality: { only_integer: true }
end
