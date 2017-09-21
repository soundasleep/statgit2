class RatioOfTestsToCode
  include ReportHelper

  attr_reader :commit

  def initialize(commit)
    @commit = commit
  end

  def call
    return 0 if test_commit.nil? || test_commit.lines_of_code.zero? || commit.lines_of_code.zero?

    test_commit.lines_of_code.to_f / (commit.lines_of_code.to_f - test_commit.lines_of_code.to_f)
  end

  private

  # The equivalent commit in the tests repository
  def test_commit
    return nil unless commit.repository.tests_repository

    commit.repository.tests_repository.commits.where(commit_hash: commit.commit_hash).first
  end
end
