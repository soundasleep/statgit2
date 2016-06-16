class CommitsPerHour
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = {}

    (0..23).each do |hour|
      result["#{hour}h"] = 0
    end

    repository.commits.each do |commit|
      hour = commit.date.hour
      result["#{hour}h"] += 1
    end

    result
  end
end
