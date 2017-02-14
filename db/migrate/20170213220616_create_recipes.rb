class CreateRecipes < ActiveRecord::Migration[5.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.float :quantity, default: 1.0
      t.boolean :public, default: false

      t.timestamps
    end
  end
end
