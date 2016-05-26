module DateHelper
  def date(date)
    iso_date(date)
  end

  def iso_date(date)
    date.strftime("%Y-%m-%d")
  end
end
