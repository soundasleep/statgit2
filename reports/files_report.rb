class FilesReport < AbstractReport
  def generate!
    create_file! "files"
  end

  def self.title
    "Files"
  end

  def self.root_path
    "files"
  end

  def self.public?
    true
  end
end

ALL_REPORTS << FilesReport
