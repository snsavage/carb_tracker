class CreateLogsStats < ActiveRecord::Migration
  def change
    create_view :logs_stats
  end
end
