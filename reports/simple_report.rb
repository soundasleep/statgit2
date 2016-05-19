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
end

ALL_REPORTS << SimpleReport
