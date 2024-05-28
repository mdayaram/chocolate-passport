# frozen_string_literal: true

# == Schema Information
#
# Table name: kases
#
#  id         :integer          not null, primary key
#  item_type  :string           not null
#  status     :text             default("new"), not null
#  workflow   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          not null
#
# Indexes
#
#  index_kases_on_item  (item_type,item_id)
#
class Kase < ApplicationRecord
  belongs_to :item, polymorphic: true

  WORKFLOW_NEW_BAR = "NEW_BAR"
end
