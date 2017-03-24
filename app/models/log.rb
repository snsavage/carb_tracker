class Log < ApplicationRecord
  belongs_to :user

  has_many :entries, inverse_of: :log
  has_many :recipes, through: :entries
  has_many :foods, through: :recipes
  has_many :logs_stats

  accepts_nested_attributes_for :entries, allow_destroy: true

  validates :entries, :log_date, presence: true
  validates :log_date, uniqueness: true

  def total_stats
    @total_stats ||= logs_stats.per_log.first
  end

  def per_recipe_stats
    @per_recipe_stats ||= logs_stats
  end

  class << self
    def daily_carb_data(user)
      where(user_id: user.id).order(log_date: :asc).limit(14).map do |log|
        [log.log_date.strftime('%B %e, %Y'), log.total_stats.total_carbs]
      end
    end
  end
end
