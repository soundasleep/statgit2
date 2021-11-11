class IdentifyAuthor < AbstractCommitAnalyser
  def can_update?
    true
  end

  def needs_update?
    commit.author.nil?
  end

  def call
    author = find_author || create_author

    # update latest author
    author.update! name: commit.author_name

    # link through to commit
    commit.update! author: author

    return true
  end

  private

  def find_author
    repository.authors.where(email: commit.author_email).first
  end

  def create_author
    repository.authors.create!(name: commit.author_name, email: commit.author_email)
  end
end
