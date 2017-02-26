module ApplicationHelper
  def num(number)
    number_with_precision(number , precision: 1)
  end
end
