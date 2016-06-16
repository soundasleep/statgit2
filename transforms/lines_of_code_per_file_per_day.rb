class LinesOfCodePerFilePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.map do |commit|
      [ iso_date(commit.date), commit.average_file_size ]
    end

    Hash[raw]
  end
end
