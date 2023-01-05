# frozen_string_literal: true

module ProcessMCellExtensions
  extend ActiveSupport::Concern

  included do
    # In development environment we can end up in an endless loop if we alias
    # the already overridden method as then it will call itself.
    alias_method :card_classes_orig, :card_classes unless method_defined?(:card_classes_orig)

    def card_classes
      original = card_classes_orig
      return original unless horizontal_card?

      "#{original} horizontal"
    end

    def resource_image_path
      model.hero_image.card.url
    end
  end

  private

  def horizontal_card?
    options[:horizontal] == true
  end
end
