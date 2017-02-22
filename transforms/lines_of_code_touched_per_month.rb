class LinesOfCodeTouchedPerMonth
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    # we don't just want days that had commits; we want ALL
    # months in between the earliest and latest commits
    date = repository.analysed_commits.first.date
    last_date = repository.analysed_commits.last.date
    raw = {}
    while date < last_date do
      raw[month_date(date)] = 0
      date += 1.month
    end

    repository.analysed_commits.each do |commit|
      raw[month_date(commit.date)] ||= 0
      raw[month_date(commit.date)] += commit.lines_of_code_touched
    end

    raw
  end
end
