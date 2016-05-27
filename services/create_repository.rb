class CreateRepository
  attr_reader :options

  def initialize(options:)
    @options = options
  end

  def call
    LOG.info "Creating repository..."

    fail "Need to provide a URL with --url" unless options[:url]

    Repository.where(url: options[:url]).first || new_repository
  end

  private

  def new_repository
    Repository.create!(
      url: options[:url],
    )
  end
end
