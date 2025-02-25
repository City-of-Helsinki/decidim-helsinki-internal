# frozen_string_literal: true

module ForceAuthenticationExtensions
  extend ActiveSupport::Concern

  included do
    # Check for all paths that should be allowed even if the user is not yet
    # authorized
    def allow_unauthorized_path?
      return true if request.path == "/consent"
      return true if unauthorized_paths.any? { |path| /^#{path}/.match?(request.path) }

      false
    end
  end
end
