class TodosReport < AbstractReport
  def title
    "TODOs"
  end

  def root_path
    "todos"
  end

  def public?
    true
  end
end

ALL_REPORTS << TodosReport
