class AuthorsReport < AbstractReport
  def generate!
    create_file! "authors"
  end

  def self.title
    "Authors"
  end

  def self.root_path
    "authors"
  end

  def self.public?
    true
  end
end

ALL_REPORTS << AuthorsReport
