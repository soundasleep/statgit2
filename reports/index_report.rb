class IndexReport < AbstractReport
  def title
    "Home"
  end

  def root_path
    "index"
  end

  def public?
    true
  end
end

ALL_REPORTS << IndexReport
