class AddLogDateToLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :logs, :log_date, :datetime
  end
end
