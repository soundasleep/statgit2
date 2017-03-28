class CountFiles < AbstractCommitAnalyser
  include CommandLineHelper

  def needs_update?
    commit.files.empty?
  end

  def call
    to_import = []

    # The transaction prevents weird open file issues in sqlite3
    ActiveRecord::Base.transaction do
      all_files_in(root_path).each do |file|
        if File.file?(file)
          file_path = file_path_for(file)
          file_size = File.new(file).size

          to_import << CommitFile.new(
            commit: commit,
            file_path_id: file_path.id,
            size: file_size
          )
        end
      end

      CommitFile.import!(to_import)
    end

    LOG.info "Found #{to_import.size} files"

    return to_import.any?
  end

  def file_path_for(path_string)
    @file_paths ||= Hash[all_file_paths]
    @file_paths[path_string] ||= repository.file_paths.create!(path: path_string)
  end

  def all_file_paths
    repository.file_paths.map do |file_path|
      [file_path.path, file_path]
    end
  end
end

COMMIT_ANALYSERS << CountFiles
