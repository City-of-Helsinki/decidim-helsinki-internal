# frozen_string_literal: true

# Overrides the update blog post command to add the extra data on the form.
module UpdateBlogPostOverrides
  extend ActiveSupport::Concern

  include Decidim::AttachmentAttributesMethods

  included do
    def update_post!
      attributes = {
        title: form.title,
        body: form.body,
        author: form.author
      }.merge(uploader_attributes)

      post.update!(attributes)
    end
  end

  private

  def uploader_attributes
    attachment_attributes(:card_image, :main_image).delete_if { |_k, val| val.blank? }
  end
end
