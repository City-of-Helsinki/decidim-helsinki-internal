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

        helper_method :posts

        def index; end

        private

        def posts
          @posts ||= search.result.order(created_at: :desc).page(params[:page]).per(12)
        end

        def search_collection
          if current_user&.admin?
            OrganizationResourceFetcher.new(Post.all, current_organization).query
          else
            PublishedResourceFetcher.new(Post.all, current_organization).query
          end
        end

        def default_filter_params
          {
            search_text_cont: "",
            decidim_component_id_eq: ""
          }
        end

        def context_params
          { user: current_user, organization: current_organization }
        end
      end
    end
  end
end
