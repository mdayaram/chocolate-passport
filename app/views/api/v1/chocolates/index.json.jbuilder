# frozen_string_literal: true

json.array! @chocolates do |bar|
  json.name bar.name
  json.form_factor bar.form_factor
  json.cacao_percentage bar.cacao_percentage
  json.front_img_url bar.front_img_url
  json.back_img_url bar.back_img_url

  json.maker bar.maker, :name, :city, :region, :country

  json.cacao_origins do
    json.array! bar.cacao_origins, :name, :city, :region, :country
  end

  json.made_in_origin bar.made_in_origin
  json.ingredients bar.ingredients.map(&:name)
  json.food_tags bar.food_tags
  json.created_at bar.created_at
  json.updated_at bar.updated_at
end
