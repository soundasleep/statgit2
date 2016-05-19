class GenerateReports
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def call
    ALL_REPORTS.each do |report|
      LOG.info("Creating report #{report}...")

      report.new(repository: repository).generate!
    end
  end
end
