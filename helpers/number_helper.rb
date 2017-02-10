require "action_view"

module NumberHelper
  include ::ActionView::Helpers::NumberHelper

  def kb_size(number)
    float_number(number / 1024.0) + " KB"
  end

  def float_number(number)
    number_with_precision(number, precision: 2, significant: false, delimiter: ",")
  end

  def percent(number)
    number_with_precision(number * 100.0, precision: 0, significant: false, delimiter: ",") + "%"
  end
end
