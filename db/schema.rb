# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170311213510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "log_id"
    t.integer  "recipe_id"
    t.float    "quantity",   default: 1.0
    t.integer  "category"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string   "food_name"
    t.float    "serving_qty"
    t.string   "serving_unit"
    t.float    "serving_weight_grams"
    t.float    "calories"
    t.float    "total_fat"
    t.float    "saturated_fat"
    t.float    "cholesterol"
    t.float    "sodium"
    t.float    "total_carbohydrate"
    t.float    "dietary_fiber"
    t.float    "sugars"
    t.float    "protein"
    t.float    "potassium"
    t.integer  "ndb_no"
    t.integer  "tag_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "unique_name"
    t.integer  "user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "food_id"
    t.float    "quantity",   default: 1.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["food_id", "recipe_id"], name: "index_ingredients_on_food_id_and_recipe_id", using: :btree
    t.index ["recipe_id", "food_id"], name: "index_ingredients_on_recipe_id_and_food_id", using: :btree
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "log_date"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.boolean  "public",       default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "serving_size", default: 1.0
    t.integer  "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end


  create_view :stats,  sql_definition: <<-SQL
      SELECT recipes.id AS recipe_id,
      ingredients.id AS ingredient_id,
      foods.id AS food_id,
      foods.food_name AS name,
      ((foods.calories * ingredients.quantity) / recipes.serving_size) AS calories,
      ((foods.total_carbohydrate * ingredients.quantity) / recipes.serving_size) AS carbs,
      ((foods.protein * ingredients.quantity) / recipes.serving_size) AS protein,
      ((foods.total_fat * ingredients.quantity) / recipes.serving_size) AS fat
     FROM ((foods
       JOIN ingredients ON ((foods.id = ingredients.food_id)))
       JOIN recipes ON ((ingredients.recipe_id = recipes.id)))
    GROUP BY recipes.id, ingredients.id, foods.id, foods.food_name
    ORDER BY recipes.id;
  SQL

  create_view :logs_stats,  sql_definition: <<-SQL
      SELECT logs.id AS log_id,
      entries.id AS entry_id,
      recipes.id AS recipe_id,
      entries.quantity,
      recipes.name AS recipe_name,
      entries.category,
      sum((stats.calories * entries.quantity)) AS calories,
      sum((stats.carbs * entries.quantity)) AS carbs,
      sum((stats.protein * entries.quantity)) AS protein,
      sum((stats.fat * entries.quantity)) AS fat
     FROM (((logs
       JOIN entries ON ((logs.id = entries.log_id)))
       JOIN recipes ON ((recipes.id = entries.recipe_id)))
       JOIN stats ON ((stats.recipe_id = entries.recipe_id)))
    GROUP BY logs.id, entries.id, recipes.id, entries.quantity, recipes.name, entries.category
    ORDER BY entries.id;
  SQL

end
