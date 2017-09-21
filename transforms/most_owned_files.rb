class MostOwnedFiles
  include ReportHelper

  attr_reader :author

  def initialize(author)
    @author = author
  end

  def call
    result = author.repository.latest_commit.commit_files_by_ownership.map do |ownership|
      ownership[author.email]
    end.compact.sort_by do |value|
      [-value[:ownership], value[:filename]]
    end.map do |value|
      # Pull out the filename to make it a hash again
      [value[:filename], value]
    end

    Hash[result]
  end
end
