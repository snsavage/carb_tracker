class Log < ApplicationRecord
  include FoodStats

  belongs_to :user

  has_many :entries, inverse_of: :log
  has_many :recipes, through: :entries
  has_many :foods, through: :recipes

  accepts_nested_attributes_for :entries, allow_destroy: true

  validates :entries, :log_date, presence: true
  validates :log_date, uniqueness: true

  def total_stats
    @total_stats ||= Log.where(id: id).total_stats.first
  end

  def per_recipe_stats
    @per_recipe_stats ||= Log.where(id: id).per_recipe_stats
  end

  def self.per_recipe_stats
    joins(entries: [recipe: [ingredients: :food]]).select(
      "recipes.name,
      (sum(foods.calories) * ingredients.quantity * entries.quantity) / recipes.serving_size AS calories,
      (sum(foods.total_carbohydrate) * ingredients.quantity * entries.quantity) / recipes.serving_size AS carbs,
      (sum(foods.protein) * ingredients.quantity * entries.quantity) / recipes.serving_size AS protein,
      (sum(foods.total_fat) * ingredients.quantity * entries.quantity) / recipes.serving_size AS fat"
    ).group("recipes.name")
  end

  def self.total_stats
    joins(entries: [recipe: [ingredients: :food]]).select(
      "logs.id,
      (sum(foods.calories) * ingredients.quantity * entries.quantity) / recipes.serving_size AS calories,
      (sum(foods.total_carbohydrate) * ingredients.quantity * entries.quantity) / recipes.serving_size AS carbs,
      (sum(foods.protein) * ingredients.quantity * entries.quantity) / recipes.serving_size AS protein,
      (sum(foods.total_fat) * ingredients.quantity * entries.quantity) / recipes.serving_size AS fat"
    ).group("logs.id")
  end
end

