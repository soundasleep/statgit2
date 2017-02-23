class TodosPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.preload(:file_todos).map do |commit|
      [ iso_date(commit.date), commit.todos ]
    end

    Hash[raw]
  end
end
