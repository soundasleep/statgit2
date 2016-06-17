module DateHelper
  def iso_date(date)
    return "" if date.nil?
    date.strftime("%Y-%m-%d")
  end

  def minute_date(date)
    return "" if date.nil?
    date.strftime("%Y-%m-%d %H:%M")
  end

  def day_name(date)
    return "" if date.nil?
    date.strftime("%a")
  end

  def time_zone
    return nil unless options[:timezone]
    @time_zone ||= ActiveSupport::TimeZone.new(options[:timezone]) or fail(invalid_timezone_error)
  end

  def invalid_timezone_error
    "Could not load timezone #{options[:timezone]}.\n\nValid timezones are:\n" +
      ActiveSupport::TimeZone.all.map(&:name).join("\n")
  end
end
