class RemovePublicFromFoods < ActiveRecord::Migration[5.0]
  def change
    remove_column :foods, :public, :boolean, default: false
  end
end
