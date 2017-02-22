class SassRulesPerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.commits.preload(:file_sass_stylesheets).map do |commit|
      [ iso_date(commit.date), commit.sass_rules ]
    end

    Hash[raw]
  end
end
