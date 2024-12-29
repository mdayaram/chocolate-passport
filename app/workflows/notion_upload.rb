# frozen_string_literal: true

require "fileutils"
require "notion"

class NotionUpload
  S3_UPLOAD_DIR = Pathname.new("catalog")
  IMG_BASE_URL = Pathname.new("https://s3.chocolatepassport.app").join(S3_UPLOAD_DIR)
  IMG1_TO_UPLOAD_DIR = Rails.root.join("tmp", "chocolates", "imgs1")
  IMG2_TO_UPLOAD_DIR = Rails.root.join("tmp", "chocolates", "imgs2")
  IMG1_DONE_DIR = Rails.root.join("tmp", "chocolates", "done1")
  IMG2_DONE_DIR = Rails.root.join("tmp", "chocolates", "done2")

  def s3_client
    @s3_client ||= Aws::S3::Client.new(
      region: Rails.application.credentials.dig(:aws, :region),
      credentials: Aws::Credentials.new(
        Rails.application.credentials.dig(:aws, :access_key_id),
        Rails.application.credentials.dig(:aws, :secret_access_key),
      ),
    )
  end

  def notion_client
    @notion_client ||= NotionClient.instance
  end

  def progress(title, size)
    ProgressBar.create(title: title, total: size, format: "%t: [%c/%C] |%B|")
  end

  def upload_to_s3(file)
    basename = File.basename(file)

    response = s3_client.put_object(
      bucket: Rails.application.credentials.dig(:aws, :bucket),
      key: S3_UPLOAD_DIR.join(basename).to_s,
      body: File.read(file),
    )

    raise "Failed to upload file! #{response}" if !response.etag

    IMG_BASE_URL.join(basename).to_s
  end

  def img1_filenames
    files = Dir.glob(IMG1_TO_UPLOAD_DIR.join("*").to_s)
    files.sort
  end

  def img2_filenames
    files = Dir.glob(IMG2_TO_UPLOAD_DIR.join("*").to_s)
    files.sort
  end

  def add_bar(front_img, back_img = nil)
    front_url = upload_to_s3(front_img)
    back_url = back_img.nil? ? nil : upload_to_s3(back_img)

    notion_payload = {
      parent: {
        type: "database_id",
        database_id: NotionClient::CHOCOLATES_DB_ID
      },
      properties: {
        "Front Image" => {
          type: "files",
          id: "%5E%3C%7Cn",
          files: [{
            external: { url: front_url },
            type: "external",
            name: front_img
          }]
        }
      }
    }

    if !back_url.nil?
      notion_payload[:properties]["Back Image"] = {
        type: "files",
        id: "",
        files: [{
          external: { url: back_url },
          type: "external",
          name: back_img
        }]
      }
    end

    result = notion_client.create_page(notion_payload)
    raise "Error when uploading to notion: #{result}" if !result["id"].present?

    if back_img.nil?
      FileUtils.mv(front_img, IMG1_DONE_DIR.join(File.basename(front_img)))
    else
      FileUtils.mv(front_img, IMG2_DONE_DIR.join(File.basename(front_img)))
      FileUtils.mv(back_img, IMG2_DONE_DIR.join(File.basename(back_img)))
    end
  end

  def ensure_paths_exist!
    FileUtils.mkdir_p IMG1_TO_UPLOAD_DIR
    FileUtils.mkdir_p IMG2_TO_UPLOAD_DIR
    FileUtils.mkdir_p IMG1_DONE_DIR
    FileUtils.mkdir_p IMG2_DONE_DIR
  end

  def run!
    ensure_paths_exist!

    # Run doubles first in case we have an odd number, we can catch the error early.
    files2 = img2_filenames
    double_progress = progress("Double Image Files", files2.size / 2)
    raise "Need even number of files, but found #{files2.size}" if files2.size.odd?

    files2.each_slice(2) do |f, b|
      add_bar(f, b)
      double_progress.increment
    end

    files1 = img1_filenames
    single_progress = progress("Single Image Files", files1.size)
    files1.each do |f|
      add_bar(f)
      single_progress.increment
    end
  end
end
