# frozen_string_literal: true

# Adds the extra fields to the admin categories form.
module AdminCategoryFormExtensions
  extend ActiveSupport::Concern

  included do
    attribute :has_color, Decidim::Form::Boolean, default: false
    attribute :color, String, default: nil
    attribute :category_image
    attribute :remove_category_image, Decidim::Form::Boolean, default: false
    attribute :category_icon
    attribute :remove_category_icon, Decidim::Form::Boolean, default: false

    validates :category_image, passthru: { to: Decidim::Category }
    validates :category_icon, passthru: { to: Decidim::Category }

    # Needed for the passthru validator
    alias_method :organization, :current_organization
  end
end
