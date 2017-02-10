class CommitsPerHour
  include ReportHelper

  attr_reader :repository_or_author

  def initialize(repository_or_author)
    @repository_or_author = repository_or_author
  end

  def call
    result = {}

    (0..23).each do |hour|
      result["#{hour}h"] = 0
    end

    repository_or_author.analysed_commits.each do |commit|
      hour = commit.date.hour
      result["#{hour}h"] += 1
    end

    result
  end
end
