module FileHelper
  def test_file?(file_path)
    commit_file = repository.latest_commit.select_file(file_path)

    return commit_file.present? && commit_file.test_file?
  end
end
