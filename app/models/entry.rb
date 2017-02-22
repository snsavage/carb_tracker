class Entry < ApplicationRecord
  belongs_to :log
  belongs_to :recipe

  enum category: {
    breakfast: 0,
    lunch: 1,
    dinner: 2,
    snack: 3
  }
end
