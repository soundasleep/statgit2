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

    repository.analysed_commits.each do |commit|
      result[commit.author.email] += 1
    end

    result.sort_by { |_email, commits| -commits }
  end
end
