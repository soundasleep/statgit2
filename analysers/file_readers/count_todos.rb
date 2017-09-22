class CountTodos < AbstractFileAnalyser
  def needs_update?
    commit.file_todos.empty?
  end

  def extension
    ""
  end

  def analyse(file, string)
    matches = string.scan(/\sTODO\s/).size
    if matches > 0
      FileTodo.new(
        commit: commit,
        commit_file: file,
        todo_count: matches,
      )
    else
      nil
    end
  end

  def import!(collection)
    FileTodo.import!(collection)
  end
end
