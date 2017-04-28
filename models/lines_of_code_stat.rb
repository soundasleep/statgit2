class LinesOfCodeStat < ActiveRecord::Base
  belongs_to :commit

  validates :language, presence: true
  validates :files, :blank, :comment, :code,
      presence: true, numericality: { only_integer: true }
end
