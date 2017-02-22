class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.integer :log_id
      t.integer :recipe_id
      t.float :quantity
      t.integer :category

      t.timestamps
    end
  end
end
