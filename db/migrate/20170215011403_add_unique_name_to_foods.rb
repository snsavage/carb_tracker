class AddUniqueNameToFoods < ActiveRecord::Migration[5.0]
  def change
    add_column :foods, :unique_name, :string
  end
end
