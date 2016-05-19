class CountFiles < AbstractCommitAnalyser
  def needs_update?
    commit.files.empty?
  end

  def call
    Dir["#{repository.root_path}**/*"].each do |file|
      relative_file = file[repository.root_path.length, file.length].strip
      if relative_file && File.file?(file)
        file_size = File.new(file).size
        commit.files.create!(
          full_path: relative_file,
          size: file_size
        )
      end
    end

    LOG.info "Found #{commit.files.size} files"
  end
end

COMMIT_ANALYSERS << CountFiles
