class CodeFilesCountPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.daily_commits.map do |commit|
      [ iso_date(commit.date), commit.code_files_count ]
    end

    Hash[raw]
  end
end
