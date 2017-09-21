class AbstractFileAnalyser < AbstractCommitAnalyser
  def can_update?
    commit.commit_files.any?
  end

  def has_already_updated?
    commit.completed_analysers.where(:class_name => self.class.name).any?
  end

  def has_updated!
    commit.completed_analysers.where(:class_name => self.class.name).first_or_create!
  end
end
