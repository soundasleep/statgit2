class AuthorsWithCommits
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = repository.authors.map do |author|
      [ author.email,
        {
          author: author,
          email: author.email,
          commits: author.commits.size,
          changes: author.changes,
          last_commit: author.last_commit,
        } ]
    end

    Hash[result]
  end
end
