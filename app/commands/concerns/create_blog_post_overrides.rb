# frozen_string_literal: true

# Overrides the create blog post command to add the extra data on the form.
module CreateBlogPostOverrides
  extend ActiveSupport::Concern

  include Decidim::AttachmentAttributesMethods

  included do
    def create_post!
      attributes = {
        title: @form.title,
        body: @form.body,
        component: @form.current_component,
        author: @form.author
      }.merge(uploader_attributes)

      @post = Decidim.traceability.create!(
        Decidim::Blogs::Post,
        @current_user,
        attributes,
        visibility: "all"
      )
    end
  end

  private

  # This is required for the `attachment_attributes` method to work correctly.
  attr_reader :form

  def uploader_attributes
    attachment_attributes(:card_image, :main_image).delete_if { |_k, val| val.blank? }
  end
end
