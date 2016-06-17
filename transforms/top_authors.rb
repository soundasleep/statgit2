class TopAuthors
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    repository.authors_with_commits.select do |key, value|
      value[:commits] > 0
    end.sort_by do |key, value|
      -value[:commits]
    end
  end
end
