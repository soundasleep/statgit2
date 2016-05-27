class GenerateReports
  attr_reader :repository, :options

  def initialize(repository:, options:)
    @repository = repository
    @options = options
  end

  def call
    LOG.info "Generating reports..."

    ALL_REPORTS.each do |report|
      LOG.info ">> #{report.name}"

      report.new(repository: repository).generate!
    end
  end
end
