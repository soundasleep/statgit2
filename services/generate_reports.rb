class GenerateReports
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def call
    LOG.info "Generating reports..."

    ALL_REPORTS.each do |report|
      LOG.info ">> #{report.name}"

      report.new(repository: repository).generate!
    end
  end
end
