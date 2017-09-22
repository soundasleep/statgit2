class SassStylesheetsPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.daily_commits.preload(:file_sass_stylesheets).map do |commit|
      [ iso_date(commit.date), commit.file_sass_stylesheets_count ]
    end

    Hash[raw]
  end
end
