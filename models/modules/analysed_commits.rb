module AnalysedCommits
  def analysed_commits
    commits.where.not(author_id: nil)
  end
end
