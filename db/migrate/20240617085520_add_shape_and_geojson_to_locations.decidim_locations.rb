# frozen_string_literal: true
# This migration comes from decidim_locations (originally 20211202091119)

class AddShapeAndGeojsonToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_locations_locations, :shape, :string
    add_column :decidim_locations_locations, :geojson, :jsonb
  end
end
