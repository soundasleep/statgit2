class ConfigReport < AbstractReport
  def title(selector = nil)
    "Configuration"
  end

  def root_path
    "config"
  end

  def public?
    true
  end
end
