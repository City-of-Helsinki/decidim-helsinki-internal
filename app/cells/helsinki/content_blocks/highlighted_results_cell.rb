# frozen_string_literal: true

module Helsinki
  module ContentBlocks
    class HighlightedResultsCell < Decidim::ViewModel
      include Decidim::ResourceHelper

      def title
        translated_attribute(model.settings.title)
      end

      def results
        @results ||= PublishedResourceFetcher.new(Decidim::Accountability::Result, current_organization).query.order(created_at: :desc).limit(4)
      end

      private

      def result_path(result)
        resource_locator(result).path
      end

      def result_image_path(result)
        return unless result.list_image

        result.list_image.url
      end

      def gallery_path
        Rails.application.routes.url_helpers.results_path
      end

      def status_label_for(result)
        return unless result.status

        style = nil
        if result.status.color
          # Get the color hex in order to decide whether to use white or black
          # foreground color for the text. In case the color is closer to fully
          # black color, we use white foreground color and vice versa.
          color_hex = result.status.color.gsub(/^#/, "").hex

          style = {
            "background-color": result.status.color,
            "color": color_hex < 0xFFFFFF / 2 ? "#fff" : "#000"
          }.map { |key, val| "#{key}:#{val}" }.join(";")
        end

        content_tag :span, class: "label", style: style do
          translated_attribute(result.status.name)
        end
      end
    end
  end
end
