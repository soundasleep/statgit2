class AbstractCommitAnalyser
  attr_reader :commit

  delegate :repository, to: :commit

  def initialize(commit:)
    @commit = commit
  end

  private

  def file_path_for(file)
    file[repository.root_path.length, file.length].strip
  end
end
