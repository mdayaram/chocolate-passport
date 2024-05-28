# frozen_string_literal: true

module Api
  module V1
    class ChocolatesController < Api::V1::BaseController
      def index
        @chocolates = Chocolate.includes(
          :maker,
          :cacao_origins,
          { ingredients: :food_tags },
        ).all
      end
    end
  end
end
