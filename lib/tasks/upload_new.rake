# frozen_string_literal: true

desc "Upload new images to the db and s3"
task upload_new: :environment do
  UploadImages.new.run!
end
