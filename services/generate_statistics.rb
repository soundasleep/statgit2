class GenerateStatistics
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def call
    LOG.info "Generating statistics..."
  end
end
