class FilesCount
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.map do |commit|
      [ iso_date(commit.date), commit.files.count ]
    end

    Hash[raw]
  end
end
