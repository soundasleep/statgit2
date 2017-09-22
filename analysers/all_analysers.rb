class AllAnalysers
  COMMIT_ANALYSERS = [
    AnalyseFiles,
    BlameWithGit,
    CountFiles,
    DiffChanges,
    IdentifyAuthor,
    LinesOfCode,
  ]

  FILE_ANALYSERS = [
    CountFixmes,
    CountTodos,
  ]
end
