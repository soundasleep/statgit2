class AbstractCommitAnalyser
  attr_reader :commit

  delegate :repository, to: :commit

  def initialize(commit:)
    @commit = commit
  end

  # Returns a truthy value if this analysis returned a non-zero result,
  # i.e. this analysis found at least one valid instance.
  #
  # This is so that we can add new analysers to the project, that are
  # automatically picked up, BUT if there are no analysis results and these
  # are valid (e.g. there are zero TODOs in the analysed code), we don't
  # accidentally get caught up trying to repeatedly test the same
  # zero-returning tests, when using --max argument.
  def call
    raise NotImplementedError, "AbstractCommitAnalyser subclass needs to implement #call"
  end

  private

  def file_path_for(file)
    file[repository.root_path.length, file.length].strip
  end
end
