# frozen_string_literal: true

module Decidim
  module Accountability
    # Exposes the result resource so users can view them
    class ResultsController < Decidim::Accountability::ApplicationController
      include FilterResource
      helper Decidim::WidgetUrlsHelper
      helper Decidim::TraceabilityHelper
      helper Decidim::Accountability::BreadcrumbHelper
      helper Decidim::TooltipHelper

      helper_method :results, :result, :first_class_categories, :count_calculator

      def show
        raise ActionController::RoutingError, "Not Found" unless can_show_result?
      end

      private

      def can_show_result?
        return true if current_user&.admin?

        result.published?
      end

      def results
        parent_id = params[:parent_id].presence
        @results ||= search.result.where(parent_id: parent_id).page(params[:page]).per(12)
      end

      def result
        @result ||= Result.includes(:timeline_entries).where(component: current_component).find(params[:id])
      end

      def search_collection
        Result.where(component: current_component).published
      end

      def default_filter_params
        {
          search_text_cont: "",
          with_scope: "",
          with_category: "",
          with_status: ""
        }
      end

      def context_params
        { component: current_component, organization: current_organization }
      end

      def first_class_categories
        @first_class_categories ||= current_participatory_space.categories.first_class
      end

      def count_calculator(scope_id, category_id)
        Decidim::Accountability::ResultsCalculator.new(current_component, scope_id, category_id).count
      end
    end
  end
end
