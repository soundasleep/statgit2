class FilesReport < AbstractReport
  def title
    "Files"
  end

  def root_path
    "files"
  end

  def public?
    true
  end
end

ALL_REPORTS << FilesReport
