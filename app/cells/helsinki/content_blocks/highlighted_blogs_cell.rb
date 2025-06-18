# frozen_string_literal: true

module Helsinki
  module ContentBlocks
    class HighlightedBlogsCell < Decidim::ViewModel
      include Decidim::ApplicationHelper # needed for html_truncate

      def title
        translated_attribute(model.settings.title)
      end

      def posts
        PublishedResourceFetcher.new(Decidim::Blogs::Post, current_organization).query.order(created_at: :desc).limit(3)
      end

      def post_path(post)
        ::Decidim::ResourceLocatorPresenter.new(post).path
      end

      private

      def resource_image_path_for(post)
        # model.images_container.attached_uploader(:background_image).path(variant: :big)
        return post.attached_uploader(:card_image).path(variant: :highlight) if post.card_image.attached?
        return post.attached_uploader(:main_image).path(variant: :highlight) if post.main_image.attached?

        asset_pack_path("media/images/placeholder-highlight.png")
      end

      def resource_description_for(post)
        body = translated_attribute(post.body)
        strip_tags html_truncate(body, length: 300, separator: "...")
      end

      def decidim_blogs
        Decidim::Blogs::Engine.routes.url_helpers
      end
    end
  end
end
