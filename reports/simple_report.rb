class SimpleReport < AbstractReport
  def generate!
    create_file! "index"
  end

  def self.title
    "Simple Report"
  end

  def self.root_path
    "index"
  end

  def self.public?
    true
  end
end

ALL_REPORTS << SimpleReport
