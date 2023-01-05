# frozen_string_literal: true

# Changes the user_has_no_permission_path to the sign in page.
module ApplicationControllerExtensions
  extend ActiveSupport::Concern

  include LongLocationUrlStoring

  included do
    def user_has_no_permission_path
      return decidim.new_user_session_path unless user_signed_in?

      decidim.root_path
    end
  end
end
