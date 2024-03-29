# frozen_string_literal: true

module Decidim
  module Comments
    # Controller that manages the comment votes.
    #
    class VotesController < Decidim::Comments::ApplicationController
      before_action :authenticate_user!
      before_action :set_comment

      helper_method :comment

      def create
        raise ActionController::RoutingError, "Not Found" unless comment

        Decidim::Comments::VoteComment.call(comment, current_user, weight: params[:weight].to_i) do
          on(:ok) do
            render :create
          end
          on(:invalid) do
            render :error
          end
        end
      end

      private

      attr_reader :comment

      def set_comment
        @comment = Decidim::Comments::Comment.find_by(id: params[:comment_id])
      end
    end
  end
end
