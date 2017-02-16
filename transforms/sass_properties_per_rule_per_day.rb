class SassPropertiesPerRulePerDay
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    raw = repository.analysed_commits.map do |commit|
      [ iso_date(commit.date), commit.sass_properties.to_f / commit.sass_rules.to_f ]
    end

    Hash[raw]
  end
end
