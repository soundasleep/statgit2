class CreateRepository
  attr_reader :options

  def initialize(options:)
    @options = options
  end

  def call
    LOG.info "Creating repository..."

    fail "Need to provide a URL with --url" unless options[:url]

    Repository.where(repository_options).first_or_create!
  end

  private

  def repository_options
    {
      parent_repository: nil,
      is_tests_only: false,
      only_paths_matching: nil,
      url: options[:url],
    }
  end
end
