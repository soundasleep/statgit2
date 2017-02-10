class ChangesByAuthor
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    result = {}

    repository.analysed_commits.each do |commit|
      commit.commit_diffs.each do |diff|
        if commit.author.present?
          changes = diff.added + diff.removed
          result[commit.author.id] ||= 0
          result[commit.author.id] += changes
        end
      end
    end

    result
  end
end
