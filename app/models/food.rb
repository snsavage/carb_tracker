class Food < ApplicationRecord
  has_many :recipes_foods
  has_many :recipes, through: :recipes_foods

  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end

  def self.search_form(search, line_delimited = false)
    klass = NutritionIx.new(search, line_delimited)

    foods = klass.foods.collect do |food|
      Food.create(food)
    end

    return [klass, foods]
  end
end
