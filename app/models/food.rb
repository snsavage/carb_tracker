class Food < ApplicationRecord

  belongs_to :user, optional: true
  has_many :ingredients
  has_many :recipes, through: :ingredients

  validates_uniqueness_of :unique_name,
    scope: :user_id, conditions: -> { from_user }

  validates_uniqueness_of :unique_name, conditions: -> { from_api }

  validates :food_name, :serving_unit, presence: true

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

  validate :user_foods_have_user_id, :api_food_does_not_have_user_id

  before_validation :set_unique_name

  def user_foods_have_user_id
    if ndb_no.blank? && user_id.blank?
      errors.add(:user_id, "created foods must have user_id")
    end
  end

  def api_food_does_not_have_user_id
    if user_id.present? && ndb_no.present?
      errors.add(:user_id, "cannot create api foods")
    end
  end

  def food_name=(name)
    super(name.titleize) if name
  end

  def serving_unit=(unit)
    super(unit.titleize) if unit
  end

  def from_api?
    ndb_no.present?
  end

  def self.from_api
    where.not(ndb_no: nil)
  end

  def self.from_user
    where(ndb_no: nil)
  end

  def self.find_or_create_from_api(foods)
    foods.collect do |food|
      new_food = Food.create(food)

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
