class IndexReport < AbstractReport
  def generate!
    create_file! "index"
  end

  def self.title
    "Home"
  end

  def self.root_path
    "index"
  end

  def self.public?
    true
  end
end

ALL_REPORTS << IndexReport
