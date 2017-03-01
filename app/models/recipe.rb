class Recipe < ApplicationRecord
  include FoodStats

  attr_accessor :search, :line_delimited

  has_many :ingredients, inverse_of: :recipe
  has_many :foods, through: :ingredients

  has_many :entries
  has_many :logs, through: :entries

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }
  validates :serving_size, numericality: { greater_than_or_equal_to: 0 }

  validates :ingredients, presence: true

  accepts_nested_attributes_for :ingredients, allow_destroy: true

  def privacy_setting
    public? ? "Public" : "Private"
  end

  def title
    name.titleize
  end

  def total_stats
    @total_stats ||= Recipe.where(id: id).total_stats.first
  end

  def per_ingredient_stats
    @per_ingredient_stats ||= Recipe.where(id: id).per_ingredient_stats
  end

  def self.total_stats
    joins(ingredients: :food).select(
      "recipes.id,
      (sum(foods.calories) * ingredients.quantity) / serving_size AS calories,
      (sum(foods.total_carbohydrate) * ingredients.quantity) / serving_size AS carbs,
      (sum(foods.protein) * ingredients.quantity) / serving_size AS protein,
      (sum(foods.total_fat) * ingredients.quantity) / serving_size AS fat"
    ).group("recipes.id")
  end

  def self.per_ingredient_stats
    joins(ingredients: :food).select(
      "foods.food_name,
      (sum(foods.calories) * ingredients.quantity) / serving_size AS calories,
      (sum(foods.total_carbohydrate) * ingredients.quantity) / serving_size AS carbs,
      (sum(foods.protein) * ingredients.quantity) / serving_size AS protein,
      (sum(foods.total_fat) * ingredients.quantity) / serving_size AS fat"
    ).group("foods.food_name")
  end

end

