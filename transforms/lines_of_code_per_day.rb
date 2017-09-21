class LinesOfCodePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.uniq do |commit|
      iso_date(commit.date)
    end.map do |commit|
      [ iso_date(commit.date), commit.lines_of_code ]
    end

    Hash[raw]
  end
end
