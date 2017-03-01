class UpdateStatsToVersion2 < ActiveRecord::Migration
  def change
    update_view :stats, version: 2, revert_to_version: 1
  end
end
