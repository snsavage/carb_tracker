class Food < ApplicationRecord
  has_many :ingredients
  has_many :recipes, through: :ingredients

  validates :unique_name, uniqueness: true
  validates :food_name, presence: true

  validates :serving_qty,
    :serving_weight_grams,
    :calories,
    :total_fat,
    :total_carbohydrate,
    :protein,
    numericality: { greater_than_or_equal_to: 0 }

  validates :saturated_fat,
    :cholesterol,
    :sodium,
    :dietary_fiber,
    :sugars,
    :potassium,
    :ndb_no,
    :tag_id,
    numericality: { greater_than_or_equal_to: 0, allow_nil: true }

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

  # def self.stats
  #   pluck(
  #     "sum(calories)",
  #     "sum(total_carbohydrate)",
  #     "sum(protein)",
  #     "sum(total_fat)"
  #   ).first
  # end

  def self.stats
    select(
      "foods.id,
      sum(calories) AS calories,
      sum(total_carbohydrate) AS carbs,
      sum(protein) AS protein,
      sum(total_fat) AS fat"
    ).group("foods.id")
  end

  private
  def set_unique_name
    self.unique_name = get_unique_name
  end
end
