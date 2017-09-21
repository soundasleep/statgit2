class CreateTestsRepository
  attr_reader :parent, :options

  def initialize(parent:, options:)
    @parent = parent
    @options = options
  end

  def call
    LOG.info "Creating test repository..."

    fail "Need to provide a URL with --url" unless options[:url]

    parent.child_repositories.where(repository_options).first_or_create!
  end

  private

  def repository_options
    {
      parent_repository: parent,
      is_tests_only: true,
      only_paths_matching: options[:tests_path],
      url: options[:url],
    }
  end
end
