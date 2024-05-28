# frozen_string_literal: true

# == Schema Information
#
# Table name: food_tags
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ingredient_id :integer          not null
#
# Indexes
#
#  index_food_tags_on_ingredient_id_and_name  (ingredient_id,name) UNIQUE
#
class FoodTag < ApplicationRecord
  belongs_to :ingredient
end
