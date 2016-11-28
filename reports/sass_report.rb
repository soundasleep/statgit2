class SassReport < AbstractReport
  def title
    "Sass"
  end

  def root_path
    "sass"
  end

  def public?
    true
  end
end

ALL_REPORTS << SassReport
