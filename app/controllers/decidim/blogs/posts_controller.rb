# frozen_string_literal: true

module Decidim
  module Blogs
    # Exposes the blog resource so users can view them
    class PostsController < Decidim::Blogs::ApplicationController
      # include Flaggable
      include FilterResource

      helper Decidim::FiltersHelper
      helper Decidim::PaginateHelper
      # helper Decidim::OrdersHelper
      helper Decidim::SanitizeHelper

      helper_method :posts, :post

      def index; end

      def show
        raise ActionController::RoutingError, "Not Found" unless can_show_post?
      end

      private

      def post
        @post ||= search.result.find(params[:id])
      end

      def posts
        @posts ||= search.result.order(created_at: :desc).page(params[:page]).per(12)
      end

      def search_collection
        Post.where(component: current_component)
      end

      def default_filter_params
        {
          search_text_cont: ""
        }
      end

      def context_params
        { user: current_user, component: current_component, organization: current_organization }
      end

      def can_show_post?
        return true if current_user&.admin?
        return false unless post.component.published?
        return false unless post.participatory_space.published?

        true
      end
    end
  end
end
