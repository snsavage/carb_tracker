class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :food_name
      t.float :serving_qty
      t.string :serving_unit
      t.float :serving_weight_grams
      t.float :calories
      t.float :total_fat
      t.float :saturated_fat
      t.float :cholesterol
      t.float :sodium
      t.float :total_carbohydrate
      t.float :dietary_fiber
      t.float :sugars
      t.float :protein
      t.float :potassium
      t.integer :ndb_no
      t.integer :tag_id

      t.timestamps
    end
  end
end
