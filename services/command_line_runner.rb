class CommandLineRunner
  attr_reader :options

  def initialize(options:)
    @options = options
  end

  def call
    repository = CreateRepository.new(options: options).call

    AnalyseRepository.new(repository: repository, options: options).call
    GenerateStatistics.new(repository: repository, options: options).call
    GenerateReports.new(repository: repository, options: options).call
  end
end
