class RemoveGitFiles < ActiveRecord::Migration
  def up
    git_file_paths = FilePath.all.select do |file_path|
      file_path.path.start_with?(".git") || file_path.path.include?("/.git/")
    end
    git_commit_files = CommitFile.where(file_path: git_file_paths)

    [CommitDiff, FileSassStylesheet, FileTodo].each do |model|
      LOG.info "Removing #{model} .git files..."
      model.where(commit_file: git_commit_files).destroy_all
    end

    LOG.info "Removing .git files..."
    git_commit_files.destroy_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Very irreversible"
  end
end
