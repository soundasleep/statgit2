class CommitActivity
  include ReportHelper

  attr_reader :repository_or_author

  def initialize(repository_or_author)
    @repository_or_author = repository_or_author
  end

  def call
    raw = repository_or_author.commits.map do |commit|
      [ minute_date(commit.date), commit.date.hour + (commit.date.min / 60.to_f) ]
    end

    Hash[raw]
  end
end
