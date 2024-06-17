# frozen_string_literal: true

module Helsinki
  module ContentBlocks
    class ImageSectionCell < IntroCell
      def has_image?
        !model.images_container.image.blank?
      end

      def image
        return unless model.images_container.image.attached?

        model.images_container.attached_uploader(:image).path(variant: :big)
      end
    end
  end
end
