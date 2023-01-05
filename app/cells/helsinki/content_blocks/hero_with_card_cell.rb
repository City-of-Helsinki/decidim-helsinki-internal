# frozen_string_literal: true

module Helsinki
  module ContentBlocks
    class HeroWithCardCell < Decidim::ViewModel
      def button1
        return if button1_url.blank?
        return if button1_text.blank?

        render
      end

      def button2
        return if button2_url.blank?
        return if button2_text.blank?

        render
      end

      def title
        translated_attribute(model.settings.title)
      end

      def description
        translated_attribute(model.settings.description)
      end

      def card_alignment_class
        "column medium-9 large-7"
      end

      def background_image
        model.images_container.background_image.big.url
      end

      def button1_url
        model.settings.button1_url
      end

      def button1_text
        translated_attribute(model.settings.button1_text)
      end

      def button1_target
        model.settings.button1_new_tab ? "_blank" : nil
      end

      def button2_url
        model.settings.button2_url
      end

      def button2_text
        translated_attribute(model.settings.button2_text)
      end

      def button2_target
        model.settings.button1_new_tab ? "_blank" : nil
      end
    end
  end
end
