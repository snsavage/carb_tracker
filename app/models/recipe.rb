class Recipe < ApplicationRecord
  has_many :recipes_foods
  has_many :foods, through: :recipes_foods
end
