class Log < ApplicationRecord
  belongs_to :user

  has_many :entries, inverse_of: :log
  has_many :recipes, through: :entries
  has_many :foods, through: :recipes
  has_many :logs_stats

  accepts_nested_attributes_for :entries, allow_destroy: true

  validates :entries, :log_date, presence: true
  validates :log_date, uniqueness: true

  def total_stats_for_chart
    {
      "Carbs": total_stats.total_carbs,
      "Protein": total_stats.total_protein,
      "Fat": total_stats.total_fat,
    }
  end

  def total_stats
    @total_stats ||= logs_stats.per_log.first
  end

  def per_recipe_stats
    @per_recipe_stats ||= logs_stats
  end

  def next(user)
    ids = user_logs_ids_by_date_asc(user)
    index = ids.find_index(id)

    if ids[index + 1]
      ids[index + 1]
    else
      nil
    end
  end

  def prev(user)
    ids = user_logs_ids_by_date_asc(user)
    index = ids.find_index(id)

    if index == 0
      nil
    else
      ids[index - 1]
    end
  end

  class << self
    def daily_carb_data(user)
      where(user_id: user.id).order(log_date: :asc).limit(14).map do |log|
        [log.log_date.strftime('%B %e, %Y'), log.total_stats.total_carbs]
      end
    end
  end

  private

  def user_logs_ids_by_date_asc(user)
    @related_logs_ids ||= user.logs.order(log_date: :asc).pluck(:id)
  end
end
