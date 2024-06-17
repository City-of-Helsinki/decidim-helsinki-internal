# frozen_string_literal: true

module Decidim
  # This class deals with uploading blog post images.
  class BlogPostImageUploader < RecordImageUploader
    # Can be used as a hero image
    set_variants do
      {
        default: { resize_to_fit: [2200, 520] },
        thumbnail: { resize_to_fit: [770, 320] },
        highlight: { resize_to_fill: [1040, 760] },
        slider: { resize_to_fill: [1180, 580] },
        list: { resize_to_fill: [1520, 750] }
      }
    end
  end
end
