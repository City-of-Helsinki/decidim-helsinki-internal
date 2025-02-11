# frozen_string_literal: true

# These would be normally required by the proposals gem but it is not loaded.
require "ransack"
require "acts_as_list"
require "cells/rails"
require "cells-erb"
require "cell/partial"

# Dummy Decidim module to provide some essentials. This lives under `/lib` in
# this project.
require "decidim"

# Require the core gems manually
require "decidim/core"
require "decidim/system"
require "decidim/admin"
require "decidim/api"

# External (after Decidim is loaded)
# require "social-share-button"
# require "social_share_button/engine"

# API extensions
require "decidim/api/extensions"

# Require the needed gems manually
require "decidim/forms"
require "decidim/verifications"
require "decidim/participatory_processes"
require "decidim/pages"
require "decidim/comments"
require "decidim/meetings"
require "decidim/surveys"
require "decidim/accountability"
# require "decidim/debates"
require "decidim/blogs"
require "decidim/templates"

# Load the Helsinki map provider
require "decidim/map/provider/helsinki"

Decidim.configure do |config|
  config.application_name = Rails.application.config.application_name
  config.mailer_sender = Rails.application.config.mailer_sender

  # Uncomment this lines to set your preferred locales
  config.default_locale = :fi
  config.available_locales = [:fi, :en, :sv]

  # Maps configuration
  config.maps = {
    provider: :helsinki,
    dynamic: {
      tile_layer: {
        url: "https://tiles.hel.ninja/styles/{style}/{z}/{x}/{y}@2x{lang}.png",
        style: "hel-osm-bright",
        max_zoom: 18,
        attribution: %(
          <a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a> contributors
        ).strip
      }
    }
  }

  # Geocoder configuration
  # config.geocoder = {
  #   static_map_url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview",
  #   here_api_key: Rails.application.secrets.maps[:api_key]
  # }

  # Currency unit
  # config.currency_unit = "€"

  # Throttling settings that may be raised for the instances
  config.throttling_max_requests = ENV.fetch("DECIDIM_THROTTLING_MAX_REQUESTS", "100").to_i
  config.throttling_period = ENV.fetch("DECIDIM_THROTTLING_PERIOD", "1").to_i.minutes

  # Extended session expiration due to the nature of the service
  config.expire_session_after = ENV.fetch("DECIDIM_EXPIRE_SESSION_AFTER", "60").to_i.minutes
end

# Configure plans
Decidim::Plans.configure do |config|
  config.section_edit_tooltips = true
  config.attachment_image_versions = {
    big: { resize_to_limit: [nil, 1000] },
    main: { resize_to_fill: [1480, 740] },
    thumbnail: { resize_to_fill: [770, 320] }
  }
  config.default_card_image = "media/images/placeholder-card.png"
end

# Configure API auth
Decidim::Apiauth.configure do |config|
  config.force_api_authentication = true
end

# Define the I18n locales.
Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
