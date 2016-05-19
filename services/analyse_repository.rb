class AnalyseRepository
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def call
    LOG.info "Analysing repository..."

  end
end
