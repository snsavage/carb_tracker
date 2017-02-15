class Food < ApplicationRecord
  has_many :recipes_foods
  has_many :recipes, through: :recipes_foods

  validates :unique_name, uniqueness: true

  before_validation :set_unique_name

  def set_unique_name
    self.unique_name = "#{food_name} - #{serving_qty} - #{serving_unit}"
  end

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
