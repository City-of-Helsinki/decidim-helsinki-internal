# frozen_string_literal: true

module Decidim
  # This class deals with uploading banner images to ParticipatoryProcesses.
  class BannerImageUploader < ImageUploader
    # Increase the dimensions from Decidim defaults
    set_variants do
      { default: { resize_to_fit: [2200, 520] } }
    end
  end
end
