class CommitFile < ActiveRecord::Base
  belongs_to :commit
  belongs_to :file_path

  has_one :commit_diff, dependent: :destroy

  has_many :file_todos, dependent: :destroy
  has_many :file_fixmes, dependent: :destroy
  has_many :file_sass_stylesheets, dependent: :destroy
  has_many :git_blames, dependent: :destroy

  validates :full_path, presence: true
  validates :size, presence: true, numericality: { only_integer: true }

  def revisions
    @revisions ||= commit.repository.revisions_for(full_path) + 1     # if a file exists, it must have had at least one commit
  end

  def contributors
    @contributors ||= commit.repository.contributors_for(full_path)
  end

  def full_path
    @full_path ||= file_path.path
  end

  def file_ownership
    @file_ownership ||= FileOwnership.new(self).call
  end

  def total_lines
    @total_lines ||= git_blames.sum(:line_count)
  end
end

