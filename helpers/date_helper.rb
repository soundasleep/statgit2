module DateHelper
  def iso_date(date)
    date.strftime("%Y-%m-%d")
  end

  def minute_date(date)
    date.strftime("%Y-%m-%d %H:%M")
  end
end
