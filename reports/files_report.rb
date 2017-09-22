class FilesReport < AbstractReport
  def title(selector = nil)
    "Files"
  end

  def root_path
    "files"
  end

  def public?
    true
  end
end
