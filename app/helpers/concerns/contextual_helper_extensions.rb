# frozen_string_literal: true

# Extensions for the Decidim::ContextualHelpHelper
module ContextualHelperExtensions
  extend ActiveSupport::Concern

  included do
    # Disable the contextual help
    def floating_help(id, &block); end
  end
end
