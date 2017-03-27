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
        file_path = file_path_for(file)
        if file_path && File.file?(file)
          file_path = file_path_for(file_path)
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

  def file_path_for(file_path)
    @file_paths ||= {}
    @file_paths[file_path] ||= FilePath.where(path: file_path).first || FilePath.create!(path: file_path)
  end
end

COMMIT_ANALYSERS << CountFiles
