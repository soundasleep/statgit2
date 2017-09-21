class TotalOwnershipPerAuthor
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

    repository.authors.each do |author|
      author.git_blames.each do |blame|
        result[author.email] += blame.line_count
      end
    end

    result.sort_by { |_email, line_count| -line_count }
  end
end
