# frozen_string_literal: true

module BlogPostMCellExtensions
  extend ActiveSupport::Concern

  def has_image?
    true
  end

  def resource_image_path
    return model.card_image.thumbnail.url if model.card_image.url
    return model.main_image.thumbnail.url if model.main_image.url

    "placeholder/card.png"
  end
end
