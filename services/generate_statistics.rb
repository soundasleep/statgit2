class GenerateStatistics
  attr_reader :repository, :options

  def initialize(repository:, options:)
    @repository = repository
    @options = options
  end

  def call
    LOG.info "Generating statistics..."
  end
end
