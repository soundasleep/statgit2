class CountFiles < AbstractCommitAnalyser
  def needs_update?
    commit.files.empty?
  end

  def call
    to_import = []

    Dir["#{root_path}**/*"].each do |file|
      file_path = file_path_for(file)
      if file_path && File.file?(file)
        file_size = File.new(file).size

        to_import << CommitFile.new(
          commit: commit,
          full_path: file_path,
          size: file_size
        )
      end
    end

    CommitFile.import!(to_import)

    LOG.info "Found #{to_import.size} files"

    return to_import.any?
  end
end

COMMIT_ANALYSERS << CountFiles
