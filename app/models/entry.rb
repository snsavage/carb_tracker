class Entry < ApplicationRecord
  belongs_to :log
  belongs_to :recipe

  enum category: {
    Breakfast: 0,
    Lunch: 1,
    Dinner: 2,
    Snack: 3
  }

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :recipe, presence: true
end
