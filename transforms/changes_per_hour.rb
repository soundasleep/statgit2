class ChangesPerHour
  include ReportHelper

  attr_reader :repository_or_author

  def initialize(repository_or_author)
    @repository_or_author = repository_or_author
  end

  def call
    result = {}

    (0..23).each do |hour|
      result["#{hour}h"] = [0, 0]
    end

    repository_or_author.analysed_commits.each do |commit|
      hour = commit.date.hour
      sums = commit.commit_diffs.select("SUM(added) AS added_sum, SUM(removed) AS removed_sum").first

      result["#{hour}h"][0] += sums.added_sum unless sums.added_sum.nil?
      result["#{hour}h"][1] -= sums.removed_sum unless sums.removed_sum.nil?
    end

    result
  end
end
