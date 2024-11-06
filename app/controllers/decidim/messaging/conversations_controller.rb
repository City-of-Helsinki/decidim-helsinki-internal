# frozen_string_literal: true

module Decidim
  module Messaging
    # Conversations are disabled for the platform
    class ConversationsController < Decidim::ApplicationController
      before_action :authenticate_user!

      def new
        redirect_to decidim.root_path
      end

      def create
        redirect_to decidim.root_path
      end

      def index
        redirect_to decidim.root_path
      end

      def show
        redirect_to decidim.root_path
      end

      def update
        redirect_to decidim.root_path
      end

      def check_multiple
        redirect_to decidim.root_path
      end
    end
  end
end
