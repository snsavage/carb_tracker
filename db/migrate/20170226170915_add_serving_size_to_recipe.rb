class AddServingSizeToRecipe < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :serving_size, :float, default: 1.0
  end
end
