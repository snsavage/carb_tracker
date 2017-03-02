class AddPublicToFoods < ActiveRecord::Migration[5.0]
  def change
    add_column :foods, :public, :boolean, default: false
  end
end
