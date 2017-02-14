class CreateRecipesFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes_foods do |t|
      t.integer :recipe_id
      t.integer :food_id
      t.float :quantity, default: 1.0

      t.index [:recipe_id, :food_id]
      t.index [:food_id, :recipe_id]

      t.timestamps
    end
  end
end
