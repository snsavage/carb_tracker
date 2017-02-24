class Recipe < ApplicationRecord
  attr_accessor :search, :line_delimited

  has_many :recipes_foods
  has_many :foods, through: :recipes_foods

  has_many :entries
  has_many :logs, through: :entries

  def privacy_setting
    public? ? "Public" : "Private"
  end

  def title
    name.titleize
  end
end
