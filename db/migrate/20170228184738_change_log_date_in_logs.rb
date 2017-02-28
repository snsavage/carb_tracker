class ChangeLogDateInLogs < ActiveRecord::Migration[5.0]
  def up
    change_column :logs, :log_date, :date
  end

  def down
    change_column :logs, :log_date, :datetime
  end
end
