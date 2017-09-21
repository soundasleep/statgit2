class RatioOfTestsToCodePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    # TODO you should be able to only select commits that have unique iso_dates,
    # which would make generating the report much faster!
    raw = repository.analysed_commits.map do |commit|
      [ iso_date(commit.date), commit.ratio_of_tests_to_code ]
    end

    Hash[raw]
  end
end
