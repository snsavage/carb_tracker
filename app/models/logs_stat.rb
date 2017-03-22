class LogsStat < ApplicationRecord
  belongs_to :log

  enum category: {
    Breakfast: 0,
    Lunch: 1,
    Dinner: 2,
    Snack: 3
  }

  def title
    recipe_name.titleize
  end

  def self.per_log
    select(
      'log_id,
      sum(calories) AS total_calories,
      sum(carbs) AS total_carbs,
      sum(protein) AS total_protein,
      sum(fat) AS total_fat'
    ).group('log_id')
  end
end
