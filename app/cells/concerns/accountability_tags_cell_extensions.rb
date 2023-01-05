# frozen_string_literal: true

module AccountabilityTagsCellExtensions
  extend ActiveSupport::Concern

  included do
    def tag_path(tag)
      filter_params = { filter: { tag_id: [tag.id] } }

      if controller.is_a?(Decidim::Accountability::Directory::ResultsController)
        Rails.application.routes.url_helpers.results_path(filter_params)
      else
        resource_locator(model).index(filter_params)
      end
    end
  end
end
