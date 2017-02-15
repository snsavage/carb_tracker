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

ActiveRecord::Schema.define(version: 20170215011403) do

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
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.boolean  "public",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "recipes_foods", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "food_id"
    t.float    "quantity",   default: 1.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["food_id", "recipe_id"], name: "index_recipes_foods_on_food_id_and_recipe_id"
    t.index ["recipe_id", "food_id"], name: "index_recipes_foods_on_recipe_id_and_food_id"
  end

end
