# frozen_string_literal: true

# == Schema Information
#
# Table name: makers
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
#  index_makers_on_name  (name) UNIQUE
#
class Maker < ApplicationRecord
  has_many :chocolates, dependent: :restrict_with_exception

  TBD_MAKER_ID = 0

  def self.tbd_maker
    @tbd_maker ||= Maker.find(TBD_MAKER_ID)
  end
end
