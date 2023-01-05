# frozen_string_literal: true

# Fixes a bug where the card_classes returned an array instead of a string as
# is expected by the views.
module CardMCellOverrides
  extend ActiveSupport::Concern

  included do
    def title
      if model.respond_to?(:title)
        translated_attribute(model.title)
      elsif model.respond_to?(:name)
        model.name
      end
    end

    def description
      attribute = model.try(:short_description) || model.try(:body) || model.description
      text = translated_attribute(attribute)

      decidim_sanitize(html_truncate(text, length: 100), strip_tags: true)
    end

    def card_classes
      classes = [base_card_class]
      classes << classes.concat(["card--stack"]) if has_children?
      return classes.join(" ") unless has_state?

      classes.concat(state_classes).join(" ")
    end
  end
end
