class UnresolvedReport < AbstractReport
  def title
    "Unresolved"
  end

  def root_path
    "unresolved"
  end

  def public?
    true
  end
end

ALL_REPORTS << UnresolvedReport
