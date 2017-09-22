class Commit < ActiveRecord::Base
  include DateHelper

  belongs_to :repository
  belongs_to :author

  has_many :commit_files, dependent: :destroy
  has_many :commit_diffs, dependent: :destroy
  has_many :file_todos, dependent: :destroy
  has_many :file_fixmes, dependent: :destroy
  has_many :file_sass_stylesheets, dependent: :destroy
  has_many :lines_of_code_stats, dependent: :destroy
  has_many :git_blames, dependent: :destroy
  has_many :completed_analysers, dependent: :destroy

  default_scope { order('author_date ASC') }

  validates :commit_hash, :short_hash, :tree_hash,
      :author_name, :author_email, :author_date, :committer_name,
      :committer_email, :committer_date, :subject, presence: true

  def date
    @date ||= author_date.in_time_zone(time_zone)
  end

  def files
    commit_files
  end

  def code_files_count
    @code_files_count ||= files.count - tests_files_count
  end

  def tests_files_count
    @tests_files_count ||= tests_commit.present? ? tests_commit.code_files_count : 0
  end

  # The commit corresponding to this commit in the tests repository, if set
  def tests_commit
    return nil unless repository.tests_repository

    repository.tests_repository.commits.where(commit_hash: commit_hash).first
  end

  def lines_of_code
    @lines_of_code ||= lines_of_code_stats.sum(:code)
  end

  def code_lines_of_code
    @code_lines_of_code ||= lines_of_code - tests_lines_of_code
  end

  def tests_lines_of_code
    @tests_lines_of_code ||= tests_commit.present? ? tests_commit.lines_of_code : 0
  end

  def commit_files_by_ownership
    @commit_files_by_ownership ||= commit_files.map(&:file_ownership)
  end

  def todos
    @todos ||= file_todos.sum(:todo_count)
  end

  def fixmes
    @fixmes ||= file_fixmes.sum(:fixme_count)
  end

  def sass_rules
    @sass_rules ||= file_sass_stylesheets_sums.rules_sum
  end

  def sass_properties
    @sass_properties ||= file_sass_stylesheets_sums.properties_sum
  end

  def file_sass_stylesheets_sums
    @file_sass_stylesheets_sums ||= file_sass_stylesheets.select("SUM(rules) AS rules_sum, SUM(properties) AS properties_sum").first
  end

  def select_file(filename)
    commit_files_as_hash[filename]
  end

  def commit_files_as_hash
    @commit_files_as_hash ||= Hash[commit_files.map { |file| [file.full_path, file] }]
  end

  def average_file_size
    @average_file_size ||= lines_of_code / files.size.to_f
  end

  def average_code_file_size
    @average_code_file_size ||= code_lines_of_code / code_files_count.to_f
  end

  def average_tests_file_size
    @average_tests_file_size ||= tests_lines_of_code / tests_files_count.to_f
  end

  def files_with_revisions_and_sizes
    @files_with_revisions_and_sizes ||= FilesWithRevisionsAndSizes.new(self).call
  end

  def lines_of_code_touched
    @lines_of_code_touched ||= commit_diffs.sum(:added) + commit_diffs.sum(:removed)
  end

  def ratio_of_tests_to_code
    @ratio_of_tests_to_code ||= RatioOfTestsToCode.new(self).call
  end
end
