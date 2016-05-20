class LinesOfCodePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.map do |commit|
      puts "commit #{commit} (#{commit.author_date}) --> #{commit.lines_of_code}"
      [ iso_date(commit.author_date), commit.lines_of_code ]
    end

    puts "raw = #{raw}"

    Hash[raw]
  end
end
