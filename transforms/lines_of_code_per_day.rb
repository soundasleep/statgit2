class LinesOfCodePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.map do |commit|
      [ iso_date(commit.author_date), commit.lines_of_code ]
    end

    Hash[raw]
  end
end
