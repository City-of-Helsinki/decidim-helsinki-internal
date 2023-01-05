# frozen_string_literal: true

# Needed because of the following bug in core:
# https://github.com/decidim/decidim/pull/7784
module MeetingPresenterExtensions
  extend ActiveSupport::Concern

  included do
    def proposals; end
  end
end
