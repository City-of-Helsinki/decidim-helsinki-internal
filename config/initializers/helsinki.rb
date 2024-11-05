# frozen_string_literal: true

require "helsinki/district_metadata"
require "helsinki/query_extensions"
require "helsinki/neighborhood_search"

Decidim::HelsinkiProfile.configure do |config|
  config.profile_authorization = false
  config.gdpr_api_enabled = false
end
