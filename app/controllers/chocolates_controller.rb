# frozen_string_literal: true

class ChocolatesController < ApplicationController
  def index
    @chocolates = Chocolate.includes(
      :maker,
      :cacao_origins,
      { ingredients: :food_tags },
    ).all
  end
end
