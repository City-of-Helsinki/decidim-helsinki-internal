# frozen_string_literal: true

# Requires sign in for the profile pages.
module PlansControllerExtensions
  extend ActiveSupport::Concern

  included do
    def default_filter_params
      {
        search_text: "",
        # with_any_origin: default_filter_origin_params,
        with_any_category: "",
        with_any_state: "",
        with_any_scope: nil,
        with_any_tag: [],
        related_to: "",
        activity: "",
        section: default_section_filter_params
      }
    end
  end
end
