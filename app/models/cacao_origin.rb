# frozen_string_literal: true

# == Schema Information
#
# Table name: cacao_origins
#
#  id         :integer          not null, primary key
#  city       :string
#  country    :string           not null
#  name       :string           not null
#  region     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  notion_id  :string           not null
#
# Indexes
#
#  index_cacao_origins_on_name  (name) UNIQUE
#
class CacaoOrigin < ApplicationRecord
  has_and_belongs_to_many :chocolates
end
