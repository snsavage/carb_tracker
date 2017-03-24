class Recipe < ApplicationRecord
  attr_accessor :search, :line_delimited

  belongs_to :user

  has_many :ingredients, inverse_of: :recipe
  has_many :foods, through: :ingredients
  has_many :entries
  has_many :logs, through: :entries
  has_many :stats

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :foods, allow_destroy: true

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }
  validates :serving_size, numericality: { greater_than_or_equal_to: 0 }
  validates :ingredients, presence: true

  def foods_attributes=(foods)
    self.foods << foods.values.collect do |attributes|
      food = Food.new(attributes)
      food.user = user

      food
    end
  end

  def privacy_setting
    public? ? 'Public' : 'Private'
  end

  def title
    name.titleize
  end

  def total_stats
    @total_stats ||= stats.per_recipe.first
  end

  def per_ingredient_stats
    @per_ingredient_stats ||= stats
  end
end
