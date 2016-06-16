class LatestCommitLanguages
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.latest_commit.lines_of_code_stats.map do |loc|
      [ loc.language, loc.code ]
    end

    Hash[raw]
  end
end
