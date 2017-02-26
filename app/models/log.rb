class Log < ApplicationRecord
  include FoodStats

  belongs_to :user

  has_many :entries, inverse_of: :log
  has_many :recipes, through: :entries
  has_many :foods, through: :recipes

  accepts_nested_attributes_for :entries, allow_destroy: true

  validates :entries, presence: true
end

