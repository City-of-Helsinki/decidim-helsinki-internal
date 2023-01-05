# frozen_string_literal: true

module ResultMCellExtensions
  extend ActiveSupport::Concern

  included do
    private

    def resource_path
      if controller.is_a?(Decidim::Accountability::Directory::ResultsController)
        Rails.application.routes.url_helpers.result_path(model)
      else
        super
      end
    end

    def display_progress?
      false
    end

    def display_data?
      false
    end
  end
end
