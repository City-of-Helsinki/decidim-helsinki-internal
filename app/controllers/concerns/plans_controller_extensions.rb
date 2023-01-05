# frozen_string_literal: true

# Requires sign in for the profile pages.
module PlansControllerExtensions
  extend ActiveSupport::Concern

  included do
    def default_filter_params
      {
        search_text: "",
        origin: default_filter_origin_params,
        activity: "",
        category_id: "",
        section: default_section_filter_params,
        state: "",
        scope_id: nil,
        related_to: "",
        tag_id: []
      }
    end
  end
end
