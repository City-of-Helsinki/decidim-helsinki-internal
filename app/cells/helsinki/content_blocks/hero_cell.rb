# frozen_string_literal: true

module Helsinki
  module ContentBlocks
    class HeroCell < Decidim::ContentBlocks::HeroCell
      def button
        return if button_url.blank?
        return if button_text.blank?

        render
      end

      def translated_title
        translated_attribute(model.settings.title)
      end

      def translated_subtitle
        translated_attribute(model.settings.subtitle)
      end

      def button_url
        model.settings.button_url
      end

      def button_text
        translated_attribute(model.settings.button_text)
      end
    end
  end
end
