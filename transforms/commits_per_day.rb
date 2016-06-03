class CommitsPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = {}

    # So that days start from Monday and are in order, but use locale strings
    (0..7).each do |offset|
      day = day_name(Date.parse("2001-01-01") + offset.days)
      result[day] = 0
    end

    repository.commits.each do |commit|
      day = day_name(commit.author_date)
      result[day] += 1
    end

    result
  end
end
