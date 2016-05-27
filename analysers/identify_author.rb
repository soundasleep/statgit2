class IdentifyAuthor < AbstractCommitAnalyser
  def needs_update?
    commit.author.nil?
  end

  def call
    author = find_author || create_author

    # update latest author
    author.update_attributes! name: commit.author_name

    # link through to commit
    commit.update_attributes! author: author
  end

  private

  def find_author
    Author.where(repository: repository, email: commit.author_email).first
  end

  def create_author
    Author.create!(repository: repository, name: commit.author_name, email: commit.author_email)
  end
end

COMMIT_ANALYSERS << IdentifyAuthor