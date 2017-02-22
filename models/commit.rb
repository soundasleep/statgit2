class Commit < ActiveRecord::Base
  include DateHelper

  belongs_to :repository
  belongs_to :author

  has_many :commit_files, dependent: :destroy
  has_many :commit_diffs, dependent: :destroy
  has_many :file_todos, dependent: :destroy
  has_many :file_sass_stylesheets, dependent: :destroy
  has_many :lines_of_code_stats, dependent: :destroy

  default_scope { order('author_date ASC') }

  def date
    @date ||= author_date.in_time_zone(time_zone)
  end

  def files
    commit_files
  end

  def lines_of_code
    @lines_of_code ||= lines_of_code_stats.sum(:code)
  end

  def todos
    @todos ||= file_todos.sum(:todo_count)
  end

  def sass_rules
    @sass_rules ||= file_sass_stylesheets.sum(:rules)
  end

  def sass_properties
    @sass_properties ||= file_sass_stylesheets.sum(:properties)
  end

  def select_file(filename)
    @select_file ||= {}
    @select_file[filename] ||= commit_files.where(full_path: filename).first
  end

  def average_file_size
    @average_file_size ||= lines_of_code / files.size.to_f
  end

  def files_with_revisions_and_sizes
    @files_with_revisions_and_sizes ||= FilesWithRevisionsAndSizes.new(self).call
  end

  def lines_of_code_touched
    @lines_of_code_touched ||= commit_diffs.sum(:added) + commit_diffs.sum(:removed)
  end
end
