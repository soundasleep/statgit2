class SassStylesheetsPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.map do |commit|
      [ iso_date(commit.date), commit.file_sass_stylesheets.count ]
    end

    Hash[raw]
  end
end
