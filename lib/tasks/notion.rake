# frozen_string_literal: true

namespace :notion do
  desc "Export current Notion data into db/seeds"
  task export: :environment do
    NotionExport.new.export!(Rails.root.join("db", "seeds"))
  end
end
