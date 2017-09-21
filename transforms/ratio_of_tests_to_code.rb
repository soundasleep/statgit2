class RatioOfTestsToCode
  include ReportHelper

  attr_reader :commit

  delegate :tests_commit, to: :commit

  def initialize(commit)
    @commit = commit
  end

  def call
    return 0 if tests_commit.nil? || tests_commit.lines_of_code.zero? || commit.lines_of_code.zero?

    tests_commit.lines_of_code.to_f / (commit.lines_of_code.to_f - tests_commit.lines_of_code.to_f)
  end
end
