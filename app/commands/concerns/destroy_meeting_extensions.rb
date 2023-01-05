# frozen_string_literal: true

# Needed because of the following bug in core:
# https://github.com/decidim/decidim/pull/7784
module DestroyMeetingExtensions
  extend ActiveSupport::Concern

  included do
    private

    def proposals
      []
    end
  end
end
