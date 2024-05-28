# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_28_192224) do
  create_table "cacao_origins", force: :cascade do |t|
    t.string "name", null: false
    t.string "city"
    t.string "region"
    t.string "country", null: false
    t.string "notion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cacao_origins_on_name", unique: true
  end

  create_table "cacao_origins_chocolates", id: false, force: :cascade do |t|
    t.integer "chocolate_id", null: false
    t.integer "cacao_origin_id", null: false
    t.index ["cacao_origin_id", "chocolate_id"], name: "idx_on_cacao_origin_id_chocolate_id_946e272b49", unique: true
    t.index ["cacao_origin_id"], name: "index_cacao_origins_chocolates_on_cacao_origin_id"
    t.index ["chocolate_id"], name: "index_cacao_origins_chocolates_on_chocolate_id"
  end

  create_table "chocolates", force: :cascade do |t|
    t.string "name"
    t.string "form_factor", null: false
    t.integer "cacao_percentage"
    t.string "front_img_url", null: false
    t.string "back_img_url"
    t.integer "maker_id", null: false
    t.string "notion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chocolates_ingredients", id: false, force: :cascade do |t|
    t.integer "chocolate_id", null: false
    t.integer "ingredient_id", null: false
    t.index ["chocolate_id", "ingredient_id"], name: "index_chocolates_ingredients_on_chocolate_id_and_ingredient_id", unique: true
    t.index ["chocolate_id"], name: "index_chocolates_ingredients_on_chocolate_id"
    t.index ["ingredient_id"], name: "index_chocolates_ingredients_on_ingredient_id"
  end

  create_table "food_tags", force: :cascade do |t|
    t.string "name", null: false
    t.integer "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id", "name"], name: "index_food_tags_on_ingredient_id_and_name", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.string "notion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "kases", force: :cascade do |t|
    t.text "workflow", null: false
    t.text "status", default: "new", null: false
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_kases_on_item"
  end

  create_table "makers", force: :cascade do |t|
    t.string "name", null: false
    t.string "city"
    t.string "region"
    t.string "country", null: false
    t.string "notion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_makers_on_name", unique: true
  end

end
