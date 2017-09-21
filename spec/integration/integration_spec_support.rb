module IntegrationSpecSupport
  shared_examples "does not capture .git files" do
    it "does not capture .git files" do
      git_files = commit_files.select { |file| file.full_path.include?(".git/") }.map { |file| file.full_path }
      expect(git_files).to be_empty
    end
  end

  def reset_workspace!
    if Dir.exist?(workspace)
      LOG.info "Resetting workspace #{workspace}"
      FileUtils.rm_r(workspace)
    end

    if File.exist?(database)
      LOG.info "Resetting database #{database}"
      File.delete(database)
    end

    connect_to_database(options)
    @repository = CreateRepository.new(options: options).call
    @tests_repository = CreateTestsRepository.new(parent: repository, options: options).call
  end

  def analyse_repository!
    AnalyseRepository.new(repository: repository, options: options).call
  end

  def analyse_tests_repository!
    AnalyseRepository.new(repository: tests_repository, options: options).call
  end

  def repository
    @repository
  end

  def tests_repository
    @tests_repository
  end
end
