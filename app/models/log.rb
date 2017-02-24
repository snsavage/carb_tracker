class Log < ApplicationRecord
  belongs_to :user

  has_many :entries, inverse_of: :log
  has_many :recipes, through: :entries

  accepts_nested_attributes_for :entries, allow_destroy: true
end
