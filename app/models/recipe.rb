class Recipe < ApplicationRecord
  include FoodStats

  attr_accessor :search, :line_delimited

  has_many :ingredients
  has_many :foods, through: :ingredients

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
end

