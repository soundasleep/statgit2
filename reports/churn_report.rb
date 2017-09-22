class ChurnReport < AbstractReport
  def title(selector = nil)
    "Churn"
  end

  def root_path
    "churn"
  end

  def public?
    true
  end
end
