class Ingredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :recipe, presence: true
  validates :food, presence: true

  class << self
    def stats_with_quantity
      joins(:food).select(
        'foods.food_name,
        sum(foods.calories) * quantity AS calories,
        sum(foods.total_carbohydrate) * quantity AS carbs,
        sum(foods.protein) * quantity AS protein,
        sum(foods.total_fat) * quantity AS fat'
      ).group('foods.food_name')
    end
  end
end
