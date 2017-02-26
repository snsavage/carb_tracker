class Recipe < ApplicationRecord
  FoodStats = Struct.new(:calories, :carbs, :protein, :fat)

  attr_accessor :search, :line_delimited

  has_many :recipes_foods
  has_many :foods, through: :recipes_foods

  has_many :entries
  has_many :logs, through: :entries

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }

  validate :at_least_one_food

  def at_least_one_food
    if foods.blank?
      errors.add(:foods, "at least one must be selected")
    end
  end

  def privacy_setting
    public? ? "Public" : "Private"
  end

  def title
    name.titleize
  end

  def stats
    calories, carbs, protein, fat = self.foods.stats
    FoodStats.new(calories, carbs, protein, fat)
  end

end

