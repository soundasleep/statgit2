class Commit < ActiveRecord::Base
  include DateHelper

  has_many :commit_files, dependent: :destroy
  has_many :commit_diffs, dependent: :destroy
  has_many :lines_of_code_stats, dependent: :destroy

  belongs_to :repository
  belongs_to :author

  default_scope { order('author_date ASC') }

  def date
    author_date.in_time_zone(time_zone)
  end

  def files
    commit_files
  end

  def lines_of_code
    lines_of_code_stats.sum(:code)
  end

  def select_file(filename)
    commit_files.where(full_path: filename).first
  end

  def average_file_size
    lines_of_code / files.size.to_f
  end
end
