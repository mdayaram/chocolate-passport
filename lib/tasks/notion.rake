# frozen_string_literal: true

namespace :notion do
  desc "Export current Notion data into db/seeds"
  task export: :environment do
    NotionExport.new.run!(Rails.root.join("db", "seeds"))
  end

  desc "Upload new images to notion and s3"
  task upload: :environment do
    NotionUpload.new.run!
  end
end
