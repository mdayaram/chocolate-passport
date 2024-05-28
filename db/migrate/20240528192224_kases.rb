# frozen_string_literal: true

class Kases < ActiveRecord::Migration[7.1]
  def change
    create_table :kases do |t|
      t.text :workflow, null: false
      t.text :status, null: false, default:  "new"
      t.references :item, polymorphic: true, null: false

      t.timestamps
    end
  end
end
