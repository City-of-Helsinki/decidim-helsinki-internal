# frozen_string_literal: true

module Decidim::Cw
  # This class deals with uploading hero images to organizations.
  class HomepageImageUploader < Decidim::Cw::ImageUploader
    version :big do
      process resize_to_fill: [2200, 680]
    end

    def max_image_height_or_width
      8000
    end
  end
end
