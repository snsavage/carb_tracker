class Food < ApplicationRecord
  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end

  def self.search_form(search, line_delimited = false)
    line_delimited = line_delimited == "true" ? true : false

    foods = NutritionIx.new(search, line_delimited)

    foods.foods.each do |food|
      Food.create(food)
    end

    return foods
  end
end
