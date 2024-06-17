# frozen_string_literal: true

module BlogPostMCellExtensions
  extend ActiveSupport::Concern

  def has_image?
    true
  end

  def resource_image_path
    return model.attached_uploader(:card_image).path(variant: :thumbnail) if model.card_image.attached?
    return model.attached_uploader(:main_image).path(variant: :thumbnail) if model.main_image.attached?

    asset_pack_path("media/images/placeholder-card.png")
  end
end
