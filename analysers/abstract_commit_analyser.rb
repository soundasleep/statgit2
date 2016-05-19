class AbstractCommitAnalyser
  attr_reader :commit

  delegate :repository, to: :commit

  def initialize(commit:)
    @commit = commit
  end
end
