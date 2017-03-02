class AddUserIdToFoods < ActiveRecord::Migration[5.0]
  def change
    add_column :foods, :user_id, :integer
  end
end
