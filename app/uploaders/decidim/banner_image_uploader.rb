# frozen_string_literal: true

module Decidim
  # This class deals with uploading banner images to ParticipatoryProcesses.
  class BannerImageUploader < ImageUploader
    # Increase the dimensions from Decidim defaults
    process resize_to_limit: [2200, 520]
  end
end
