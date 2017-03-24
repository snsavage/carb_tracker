class Stat < ApplicationRecord
  belongs_to :recipe

  class << self
    def per_recipe
      select(
        'recipe_id,
        sum(calories) AS total_calories,
        sum(carbs) AS total_carbs,
        sum(protein) AS total_protein,
        sum(fat) AS total_fat'
      ).group('recipe_id')
    end
  end
end
