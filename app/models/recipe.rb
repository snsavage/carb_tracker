class Recipe < ApplicationRecord
  attr_accessor :search, :line_delimited

  has_many :recipes_foods
  has_many :foods, through: :recipes_foods

  def privacy_setting
    public? ? "Public" : "Private"
  end
end
