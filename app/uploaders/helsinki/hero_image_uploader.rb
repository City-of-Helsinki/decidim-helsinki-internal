# frozen_string_literal: true

module Helsinki
  # This class deals with uploading hero section images to the front page
  # content blocks.
  class HeroImageUploader < Decidim::ImageUploader
    version :big do
      process resize_to_fill: [2200, 680]
    end

    def max_image_height_or_width
      4000
    end
  end
end
