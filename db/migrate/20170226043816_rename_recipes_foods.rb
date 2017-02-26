class RenameRecipesFoods < ActiveRecord::Migration[5.0]
  def change
    rename_table :recipes_foods, :ingredients
  end
end
