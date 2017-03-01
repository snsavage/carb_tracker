class RemoveFoodLogs < ActiveRecord::Migration[5.0]
  # def up
  #   drop_table :food_logs
  #   drop_table :food_logs_recipes
  # end

  # def down
  #   create_table "food_logs", force: :cascade do |t|
  #     t.float    "quantiy"
  #     t.datetime "date"
  #     t.integer  "category"
  #     t.datetime "created_at", null: false
  #     t.datetime "updated_at", null: false
  #   end

  #   create_table "food_logs_recipes", force: :cascade do |t|
  #     t.integer  "food_log_id"
  #     t.integer  "recipe_id"
  #     t.float    "quantity",    default: 1.0
  #     t.datetime "created_at",                null: false
  #     t.datetime "updated_at",                null: false
  #   end
  # end
end
