class ChurnReport < AbstractReport
  def title
    "Churn"
  end

  def root_path
    "churn"
  end

  def public?
    true
  end
end

ALL_REPORTS << ChurnReport
