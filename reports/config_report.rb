class ConfigReport < AbstractReport
  def title
    "Configuration"
  end

  def root_path
    "config"
  end

  def public?
    true
  end
end

ALL_REPORTS << ConfigReport
