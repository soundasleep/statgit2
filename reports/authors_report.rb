class AuthorsReport < AbstractReportCollection
  def title(selector = nil)
    if selector.present?
      selector.email
    else
      "Authors"
    end
  end

  def root_path
    "authors"
  end

  def public?
    true
  end

  def all_reports
    repository.authors.compact
  end

  def file_for_selector(author)
    author.email
  end
end

ALL_REPORTS << AuthorsReport
