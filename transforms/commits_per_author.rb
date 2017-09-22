class CommitsPerAuthor
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = repository.authors.map do |author|
      [ author.email, 0 ]
    end
    result = Hash[result]

    repository.analysed_commits
        .joins(:author)
        .select("authors.email as author_email, COUNT(*) AS commit_count")
        .group("authors.id")
        .each do |row|
      result[row.author_email] += row.commit_count
    end

    result.sort_by { |_email, commits| -commits }
  end
end
