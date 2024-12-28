# frozen_string_literal: true

require "notion"

class NotionExport
  MAKERS_DB_ID = "bef194e8978a4e00a9b58a7065b8d726"
  ORIGINS_DB_ID = "6eba1f2c70894fcda8f3068a4d8d6b19"
  INGREDIENTS_DB_ID = "4d04e745065945af9ae34dcffbe6d1be"
  CHOCOLATES_DB_ID = "94cdf579ddae4fd593a069d625704657"

  def client
    # Uses Rails.credentials for notion token, configured at initialization.
    @client ||= Notion::Client.new
  end

  def export!(path)
    export_ingredients!(path.join("ingredients.json"))
    export_origins!(path.join("origins.json"))
    export_makers!(path.join("makers.json"))
    export_chocolates!(path.join("chocolates.json"))
  end

  def export_ingredients!(filepath)
    ingredients = {}

    query_into_hash(ingredients, INGREDIENTS_DB_ID) do |row|
      ingredients[row.id]["tags"] = row.properties.Category.multi_select.map(&:name)
    end

    write_to_pathfile(filepath, ingredients)
    ingredients
  end

  def export_origins!(filepath)
    origins = {}

    query_into_hash(origins, ORIGINS_DB_ID) do |row|
      origins[row.id]["city"] = row.properties.City.multi_select.first&.name
      origins[row.id]["region"] = row.properties.Region.multi_select.first&.name
      origins[row.id]["country"] = row.properties.Country.multi_select.first&.name
    end

    write_to_pathfile(filepath, origins)
    origins
  end

  def export_makers!(filepath)
    makers = {}

    query_into_hash(makers, MAKERS_DB_ID) do |row|
      makers[row.id]["city"] = row.properties.City["select"]&.name
      makers[row.id]["region"] = row.properties["State / Region"]["select"]&.name
      makers[row.id]["country"] = row.properties.Country["select"].name
    end

    write_to_pathfile(filepath, makers)
    makers
  end

  def export_chocolates!(filepath)
    chocos = {}

    query_into_hash(chocos, CHOCOLATES_DB_ID) do |row|
      chocos[row.id]["front_img_url"] = row.properties["Front Image"].files[0].external.url
      chocos[row.id]["back_img_url"] = row.properties["Back Image"].files.first&.external&.url
      chocos[row.id]["form_factor"] = row.properties["Form Factor"]["select"].name
      chocos[row.id]["cacao_origin_id"] = row.properties["Cacao Origin"].relation.map(&:id)
      chocos[row.id]["cacao_percentage"] = row.properties["Cacao Percentage"].number
      chocos[row.id]["maker_id"] = row.properties.Maker.relation.map(&:id)
      chocos[row.id]["ingredient_ids"] = row.properties.Ingredients.relation.map(&:id)
    end

    write_to_pathfile(filepath, chocos)
    chocos
  end

  private

  def write_to_pathfile(pathfile, data)
    json = JSON.pretty_generate(data)
    pathfile.open("w") { |f| f.write(json) }
  end

  def query_into_hash(hash, dbid)
    client.database_query(database_id: dbid) do |page|
      page.results.each do |row|
        hash[row.id] = {}
        hash[row.id]["name"] = row.properties.Name.title[0].plain_text
        hash[row.id]["created_at"] = row.created_time
        hash[row.id]["updated_at"] = row.last_edited_time

        yield(row) if block_given?
      end
    end

    hash
  end
end
