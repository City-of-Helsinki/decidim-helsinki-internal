# frozen_string_literal: true

module Decidim
  module Accountability
    module Directory
      # Exposes the result resource so users can view them
      class ResultsController < Decidim::ApplicationController
        layout "layouts/decidim/application"

        helper Decidim::FiltersHelper
        helper Decidim::PaginateHelper
        helper Decidim::OrdersHelper
        helper Decidim::SanitizeHelper

        include FilterResource
        helper Decidim::WidgetUrlsHelper
        helper Decidim::TraceabilityHelper
        # helper Decidim::Accountability::ApplicationHelper
        helper Decidim::Accountability::BreadcrumbHelper
        helper Decidim::TooltipHelper

        helper_method :results, :result, :first_class_categories, :count_calculator, :component_settings

        before_action :set_lookup_prefixes, only: [:show]

        def show
          raise ActionController::RoutingError, "Not Found" unless can_show_result?

          render "decidim/accountability/results/show"
        end

        private

        def set_lookup_prefixes
          lookup_context.prefixes << "decidim/accountability/results"
        end

        def can_show_result?
          return true if current_user&.admin?

          result.published?
        end

        def results
          parent_id = params[:parent_id].presence
          @results ||= search.results.joins(:component).where(parent_id: parent_id).order("decidim_components.created_at" => :desc, created_at: :desc).page(params[:page]).per(12)
        end

        def result
          @result ||= Result.includes(:timeline_entries).find(params[:id])
        end

        def search_klass
          ResultSearch
        end

        def default_filter_params
          {
            search_text: "",
            scope_id: "",
            category_id: "",
            component_id: "",
            status: ""
          }
        end

        def context_params
          { organization: current_organization }
        end

        # def first_class_categories
        #   @first_class_categories ||= current_participatory_space.categories.first_class
        # end

        # def count_calculator(scope_id, category_id)
        #   Decidim::Accountability::ResultsCalculator.new(current_component, scope_id, category_id).count
        # end

        def component_settings
          return unless result

          @component_settings ||= result.component.settings
        end
      end
    end
  end
end
