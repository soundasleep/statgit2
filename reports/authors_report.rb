class AuthorsReport < AbstractReport
  def title
    "Authors"
  end

  def root_path
    "authors"
  end

  def public?
    true
  end
end

ALL_REPORTS << AuthorsReport
