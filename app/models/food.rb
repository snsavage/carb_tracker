class Food < ApplicationRecord
  has_many :recipes_foods
  has_many :recipes, through: :recipes_foods

  validates :unique_name, uniqueness: true

  before_validation :set_unique_name

  def get_unique_name
    "#{food_name} - #{serving_qty} - #{serving_unit}"
  end

  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end

  def self.find_or_create_from_api(foods)
    foods.collect do |food|
      new_food = create(food)

      if new_food.invalid?
        find_by_unique_name(new_food.get_unique_name)
      else
        new_food
      end
    end
  end

  private
  def set_unique_name
    self.unique_name = get_unique_name
  end
end
