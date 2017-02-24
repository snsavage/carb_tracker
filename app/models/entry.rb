class Entry < ApplicationRecord
  belongs_to :log
  belongs_to :recipe

  enum category: {
    Breakfast: 0,
    Lunch: 1,
    Dinner: 2,
    Snack: 3
  }
end
