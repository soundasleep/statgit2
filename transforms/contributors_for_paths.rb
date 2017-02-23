class ContributorsForPaths
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = {}

    repository.analysed_commits.preload(:commit_diffs).each do |commit|
      commit.commit_diffs.each do |diff|
        path = diff.commit_file.full_path
        result[path] ||= Set.new
        result[path] << commit.author
      end
    end

    out = result.map do |path, contributors|
      [path, contributors.count]
    end

    Hash[out]
  end
end
