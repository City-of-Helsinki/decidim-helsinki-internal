# frozen_string_literal: true

module Decidim
  module Helsinki
    # This class deals with uploading hero section images to the front page
    # content blocks.
    class HeroImageUploader < Decidim::ImageUploader
      set_variants do
        {
          big: { resize_to_fit: [2200, 680] }
        }
      end

      def max_image_height_or_width
        4000
      end
    end
  end
end
