# frozen_string_literal: true

module NotionClient
  extend self

  MAKERS_DB_ID = "bef194e8978a4e00a9b58a7065b8d726"
  ORIGINS_DB_ID = "6eba1f2c70894fcda8f3068a4d8d6b19"
  INGREDIENTS_DB_ID = "4d04e745065945af9ae34dcffbe6d1be"
  CHOCOLATES_DB_ID = "94cdf579ddae4fd593a069d625704657"

  def instance
    # Uses Rails.credentials for notion token, configured at initialization.
    @instance ||= Notion::Client.new
  end
end
