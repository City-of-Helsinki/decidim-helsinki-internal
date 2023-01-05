# frozen_string_literal: true

module Decidim
  module Blogs
    module Directory
      module PostsHelper
        # Fixes an issue that the routes are fetched from the engine instead
        # of the main app in the posts directory views / controllers.
        def _routes
          return main_app.routes if controller.is_a?(Decidim::Blogs::Directory::PostsController)

          super
        end
      end
    end
  end
end
