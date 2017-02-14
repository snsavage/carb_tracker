class Food < ApplicationRecord
  has_many :recipes_foods
  has_many :recipes, through: :recipes_foods

  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end

  def self.search_form(search, line_delimited = false)
    foods = NutritionIx.new(search, line_delimited)

    foods.foods.each do |food|
      Food.create(food)
    end

    return foods
  end
end
