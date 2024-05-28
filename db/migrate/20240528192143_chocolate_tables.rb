# frozen_string_literal: true

class ChocolateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.string :notion_id, null: false
      t.timestamps

      t.index :name, unique: true
    end

    create_table :food_tags do |t|
      t.string :name, null: false
      t.integer :ingredient_id, null: false

      t.timestamps
      t.index %i[ingredient_id name], unique: true
    end

    create_table :cacao_origins do |t|
      t.string :name, null: false
      t.string :city
      t.string :region
      t.string :country, null: false
      t.string :notion_id, null: false

      t.timestamps

      t.index :name, unique: true
    end

    create_table :makers do |t|
      t.string :name, null: false
      t.string :city
      t.string :region
      t.string :country, null: false
      t.string :notion_id, null: false

      t.timestamps

      t.index :name, unique: true
    end

    create_table :chocolates do |t|
      t.string :name
      t.string :form_factor, null: false
      t.integer :cacao_percentage
      t.string :front_img_url, null: false
      t.string :back_img_url
      t.integer :maker_id, null: false
      t.string :notion_id, null: false

      t.timestamps
    end

    create_table :cacao_origins_chocolates, id: false do |t|
      t.belongs_to :chocolate, null: false
      t.belongs_to :cacao_origin, null: false

      t.index %i[cacao_origin_id chocolate_id], unique: true
    end

    create_table :chocolates_ingredients, id: false do |t|
      t.belongs_to :chocolate, null: false
      t.belongs_to :ingredient, null: false

      t.index %i[chocolate_id ingredient_id], unique: true
    end
  end
end
