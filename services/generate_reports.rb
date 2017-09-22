class GenerateReports
  attr_reader :repository, :options

  def initialize(repository:, options:)
    @repository = repository
    @options = options
  end

  def call
    LOG.info "Generating reports..."

    repository.reload

    AllReports::REPORTS.each do |report|
      instance = report.new(repository: repository)

      LOG.info ">> #{instance.name}"

      instance.generate!
    end
  end
end
