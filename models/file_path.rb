class FilePath < ActiveRecord::Base
  belongs_to :repository

  has_many :commit_files, dependent: :destroy

  validates :path, presence: true
  validate :cannot_be_a_git_file, :standard_path_separator

  private

  def cannot_be_a_git_file
    if path.starts_with?(".git/")
      errors.add(:path, "'#{path}' can't start with .git")
    end
  end

  def standard_path_separator
    if path.include?("\\")
      errors.add(:path, "expected standard path separator /")
    end
  end
end
