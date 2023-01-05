# frozen_string_literal: true

module Decidim
  module Blogs
    module Directory
      # Exposes the blog resources in all components for users
      class PostsController < Decidim::ApplicationController
        include FilterResource

        layout "layouts/decidim/application"

        helper Decidim::FiltersHelper
        helper Decidim::PaginateHelper
        # helper Decidim::OrdersHelper
        helper Decidim::SanitizeHelper
        helper Decidim::FilterParamsHelper

        helper_method :posts

        def index; end

        private

        def posts
          @posts ||= search.results.order(created_at: :desc).page(params[:page]).per(12)
        end

        def search_klass
          PostSearch
        end

        def default_filter_params
          {
            search_text: "",
            component_id: ""
          }
        end

        def context_params
          { user: current_user, organization: current_organization }
        end
      end
    end
  end
end
