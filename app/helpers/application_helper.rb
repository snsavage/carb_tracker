module ApplicationHelper
  def num(number)
    number_with_precision(number, precision: 1)
  end

  def date(date)
    date.strftime('%A, %B %e, %Y')
  end
end
