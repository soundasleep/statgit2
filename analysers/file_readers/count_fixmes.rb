class CountFixmes < AbstractFileAnalyser
  def needs_update?
    commit.file_fixmes.empty?
  end

  def extension
    ""
  end

  def analyse(file, string)
    matches = string.scan(/\sFIXME\s/).size
    if matches > 0
      FileFixme.new(
        commit: commit,
        commit_file: file,
        fixme_count: matches,
      )
    else
      nil
    end
  end

  def import!(collection)
    FileFixme.import!(collection)
  end
end
