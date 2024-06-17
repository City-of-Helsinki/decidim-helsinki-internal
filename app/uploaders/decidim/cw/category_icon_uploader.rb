# frozen_string_literal: true

module Decidim::Cw
  # This class deals with uploading the category icons.
  class CategoryIconUploader < Decidim::Cw::ApplicationUploader
    def content_type_whitelist
      %w(image/svg+xml image/svg image/png)
    end

    def extension_whitelist
      %w(svg png)
    end
  end
end
