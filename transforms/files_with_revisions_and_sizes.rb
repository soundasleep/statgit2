class FilesWithRevisionsAndSizes
  include ReportHelper

  attr_reader :commit

  def initialize(commit)
    @commit = commit
  end

  def call
    result = commit.files
        .preload(:file_todos, :file_fixmes, :file_sass_stylesheets)
        .map do |file|
      [ file.full_path,
        {
          filename: file.full_path,
          revisions: file.revisions,
          size: file.size,
          todos: file.file_todos.any? ? file.file_todos.first.todo_count : 0,
          fixmes: file.file_fixmes.any? ? file.file_fixmes.first.fixme_count : 0,
          sass_rules: file.file_sass_stylesheets.any? ? file.file_sass_stylesheets.first.rules : 0,
          contributors: file.contributors,
        } ]
    end

    Hash[result]
  end
end
