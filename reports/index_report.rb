class IndexReport < AbstractReport
  def title(selector = nil)
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
