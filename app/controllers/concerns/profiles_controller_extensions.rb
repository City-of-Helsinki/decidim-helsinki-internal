# frozen_string_literal: true

# Requires sign in for the profile pages.
module ProfilesControllerExtensions
  extend ActiveSupport::Concern

  include RequiresSignIn

  included do
    before_action do
      enforce_permission_to :read, :profiles
    end
  end
end
