# frozen_string_literal: true

# == Schema Information
#
# Table name: chocolates
#
#  id               :integer          not null, primary key
#  back_img_url     :string
#  cacao_percentage :integer
#  form_factor      :string           not null
#  front_img_url    :string           not null
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  maker_id         :integer          not null
#  notion_id        :string           not null
#
class Chocolate < ApplicationRecord
  belongs_to :maker
  has_and_belongs_to_many :cacao_origins
  has_and_belongs_to_many :ingredients

  def food_tags
    ingredients.map(&:food_tags).flatten.map(&:name).uniq
  end

  def made_in_origin
    cacao_origins.any? { |o| o.country == maker.country }
  end
end
