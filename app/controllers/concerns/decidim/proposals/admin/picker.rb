# frozen_string_literal: true

# Needed because of the following bugs in core:
# https://github.com/decidim/decidim/pull/7784
# https://github.com/decidim/decidim/pull/7785
module Decidim
  module Proposals
    module Admin
      module Picker
        extend ActiveSupport::Concern

        def proposals_picker; end
      end
    end
  end
end
