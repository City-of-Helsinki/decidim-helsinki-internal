# frozen_string_literal: true

module UserProfileCellExtensions
  extend ActiveSupport::Concern

  included do
    def has_badge?
      return unless model.is_a?(Decidim::User)

      model.providing_help?
    end
  end
end
