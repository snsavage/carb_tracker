class Food < ApplicationRecord

  belongs_to :user
  has_many :ingredients
  has_many :recipes, through: :ingredients

  validates :unique_name, uniqueness: true
  validates :food_name, :serving_unit, presence: true
  validates :public, inclusion: { in: [true, false] }

  validates :serving_qty,
    :calories,
    :total_fat,
    :total_carbohydrate,
    :protein,
    numericality: { greater_than_or_equal_to: 0 }

  validates :saturated_fat,
    :serving_weight_grams,
    :cholesterol,
    :sodium,
    :dietary_fiber,
    :sugars,
    :potassium,
    :ndb_no,
    :tag_id,
    numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  before_validation :set_unique_name

  def display
    "#{food_name.titleize} - #{serving_qty} - #{serving_unit}"
  end

  def food_name=(name)
    super(name.titleize) if name
  end

  def serving_unit=(unit)
    super(unit.titleize) if unit
  end

  def self.find_or_create_from_api(foods, user)
    foods.collect do |food|
      new_food = user.foods.create(food)

      if new_food.invalid?
        find_by_unique_name(new_food.unique_name)
      else
        new_food
      end
    end
  end

  private
  def set_unique_name
    self.unique_name = "#{food_name} - #{serving_qty} - #{serving_unit}"
  end
end
