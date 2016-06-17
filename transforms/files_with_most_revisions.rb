class FilesWithMostRevisions
  include ReportHelper

  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def call
    # TODO could move this into a method on Repository for optimize
    raw = repository.latest_commit.files.map do |file|
      [ file.full_path,
        {
          filename: file.full_path,
          revisions: file.revisions,
          size: file.size,
        } ]
    end

    Hash[raw].select do |key, value|
      value[:revisions] > 0
    end.sort_by do |key, value|
      -value[:revisions]
    end
  end
end
