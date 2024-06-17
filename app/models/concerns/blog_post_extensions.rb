# frozen_string_literal: true

# Adds the extra fields to blog posts.
module BlogPostExtensions
  extend ActiveSupport::Concern

  include Decidim::HasUploadValidations

  included do
    has_one_attached :card_image
    validates_upload :card_image, uploader: Decidim::BlogPostImageUploader

    has_one_attached :main_image
    validates_upload :main_image, uploader: Decidim::BlogPostImageUploader

    # Needed for the uploaders to get the allowed file extensions
    attr_writer :organization

    # The local @organization variable is set by the passthru validator. If not
    # set, return the participatory space's organization.
    def organization
      @organization || participatory_space&.organization
    end
  end
end
