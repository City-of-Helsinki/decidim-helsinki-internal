# frozen_string_literal: true

module Decidim::Cw
  # This class deals with uploading banner images to ParticipatoryProcesses.
  class BannerImageUploader < Decidim::Cw::ImageUploader
    # Increase the dimensions from Decidim defaults
    process resize_to_limit: [2200, 520]
  end
end
