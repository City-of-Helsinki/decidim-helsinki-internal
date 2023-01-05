# frozen_string_literal: true

module Decidim
  module Accountability
    module Directory
      module ResultsHelper
        include Decidim::AttachmentsHelper
        include Decidim::Comments::CommentsHelper
        include Decidim::AccountabilitySimple::ApplicationHelperExtensions

        # Fixes an issue that the routes are fetched from the engine instead
        # of the main app in the results directory views / controllers.
        def _routes
          return main_app.routes if controller.is_a?(Decidim::Accountability::Directory::ResultsController)

          super
        end
      end
    end
  end
end
