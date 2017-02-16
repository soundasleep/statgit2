class RevisionsForPaths
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = {}

    repository.analysed_commits.each do |commit|
      commit.commit_diffs.each do |diff|
        path = diff.commit_file.full_path
        result[path] ||= 1
        result[path] += 1
      end
    end

    result
  end
end
