# frozen_string_literal: true

module Decidim
  # This class deals with uploading blog post images.
  class BlogPostImageUploader < RecordImageUploader
    # Can be used as a hero image
    process resize_to_limit: [2200, 520]

    version :thumbnail do
      process resize_to_fill: [770, 320]
    end

    version :highlight do
      process resize_to_fill: [1040, 760]
    end

    version :slider do
      process resize_to_fill: [1180, 580]
    end

    version :list do
      process resize_to_fill: [1520, 750]
    end
  end
end
