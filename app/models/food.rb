class Food < ApplicationRecord
  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end
end
