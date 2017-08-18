class FixmesPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.preload(:file_fixmes).map do |commit|
      [ iso_date(commit.date), commit.fixmes ]
    end

    Hash[raw]
  end
end
