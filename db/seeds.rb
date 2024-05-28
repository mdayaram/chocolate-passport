# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Make a TBD Maker
tbd_maker = Maker.find_or_create_by(id: Maker::TBD_MAKER_ID) do |m|
  m.name = ""
  m.notion_id = ""
  m.country = ""
end

raise "Unknown maker using reserved ID: #{Maker::TBD_MAKER_ID}: #{tbd_maker}" if !tbd_maker.nil? && !tbd_maker.name.empty?

def progressbar(name, count)
  ProgressBar.create(title: "db:seed #{name}", total: count, format: "%t: [%c/%C] |%B|")
end

import_files_dir = Rails.root.join("db", "seeds")
ingredients_file = import_files_dir.join("ingredients.json").to_s
origins_file = import_files_dir.join("origins.json").to_s
makers_file = import_files_dir.join("makers.json").to_s
chocolates_file = import_files_dir.join("chocolates.json").to_s

ingredients = JSON.parse(File.read(ingredients_file))
ingredient_progress = progressbar("Ingredients", ingredients.size)
ingredients.each do |notion_id, ing|
  ning = Ingredient.create!(
    notion_id: notion_id,
    name: ing["name"],
    created_at: ing["created_at"],
    updated_at: ing["updated_at"],
  )
  ingredient_progress.increment
  ning.food_tags = ing["tags"].map { |t| FoodTag.new(name: t) }
  ning.save!
end

origins = JSON.parse(File.read(origins_file))
origins_progress = progressbar("Origins", origins.size)
origins.each do |notion_id, orig|
  CacaoOrigin.create!(
    notion_id: notion_id,
    name: orig["name"],
    created_at: orig["created_at"],
    updated_at: orig["updated_at"],
    city: orig["city"],
    region: orig["region"],
    country: orig["country"],
  )
  origins_progress.increment
end

makers = JSON.parse(File.read(makers_file))
maker_progress = progressbar("Makers", makers.size)
makers.each do |notion_id, mak|
  Maker.create!(
    notion_id: notion_id,
    name: mak["name"],
    created_at: mak["created_at"],
    updated_at: mak["updated_at"],
    city: mak["city"],
    region: mak["region"],
    country: mak["country"],
  )
  maker_progress.increment
end

chocolates = JSON.parse(File.read(chocolates_file))
chocolate_progress = progressbar("Chocolates", chocolates.size)
chocolates.each do |notion_id, choco|
  origins = CacaoOrigin.where(notion_id: choco["cacao_origin_id"])
  makers = Maker.where(notion_id: choco["maker_id"])
  ingredients = Ingredient.where(notion_id: choco["ingredient_ids"])

  # Validate the relationships.
  raise "failed origins check" if origins.size != choco["cacao_origin_id"].size
  raise "failed maker check" if makers.size != choco["maker_id"].size && makers.size == 1
  raise "failed ingredient check" if ingredients.size != choco["ingredient_ids"].size

  nchoc = Chocolate.create!(
    notion_id: notion_id,
    name: choco["name"],
    created_at: choco["created_at"],
    updated_at: choco["updated_at"],
    maker: makers.first,
    front_img_url: choco["front_img_url"],
    back_img_url: choco["back_img_url"],
    form_factor: choco["form_factor"],
    cacao_percentage: choco["cacao_percentage"].nil? ? nil : (choco["cacao_percentage"] * 100).to_i,
  )

  nchoc.cacao_origins = origins
  nchoc.ingredients = ingredients
  nchoc.save!
  chocolate_progress.increment
end
