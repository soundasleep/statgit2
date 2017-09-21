class AbstractFileAnalyser < AbstractCommitAnalyser
  def can_update?
    commit.commit_files.any?
  end
end
