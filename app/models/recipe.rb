class Recipe < ApplicationRecord
  include FoodStats

  attr_accessor :search, :line_delimited

  has_many :ingredients, inverse_of: :recipe
  has_many :foods, through: :ingredients

  has_many :entries
  has_many :logs, through: :entries

  validates :name, presence: true
  validates :public, inclusion: { in: [true, false] }

  validates :ingredients, presence: true

  accepts_nested_attributes_for :ingredients, allow_destroy: true

  def privacy_setting
    public? ? "Public" : "Private"
  end

  def title
    name.titleize
  end
end

