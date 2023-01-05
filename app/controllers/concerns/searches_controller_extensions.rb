# frozen_string_literal: true

# Adds new filter params to the searches and requires sign in.
module SearchesControllerExtensions
  extend ActiveSupport::Concern

  include RequiresSignIn

  included do
    before_action do
      enforce_permission_to :read, :searches
    end

    def default_filter_params
      {
        term: params[:term],
        resource_type: nil,
        decidim_scope_id: nil,
        subtype: "all"
      }
    end
  end
end
