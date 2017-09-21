class SassStylesheetsPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.preload(:file_sass_stylesheets).uniq do |commit|
      iso_date(commit.date)
    end.map do |commit|
      [ iso_date(commit.date), commit.file_sass_stylesheets.count ]
    end

    Hash[raw]
  end
end
