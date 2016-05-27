class CommitActivity
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.map do |commit|
      [ minute_date(commit.author_date), commit.author_date.hour + (commit.author_date.min / 60.to_f) ]
    end

    Hash[raw]
  end
end
