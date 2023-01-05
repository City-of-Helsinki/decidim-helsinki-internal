# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module ContentBlocks
      class HighlightedProcessesCell < Decidim::ViewModel
        include Decidim::ApplicationHelper
        include Decidim::SanitizeHelper
        include Decidim::CardHelper
        include Cell::ViewModel::Partial
        include ParticipatoryProcessHelper
        include Decidim::ParticipatoryProcesses::Engine.routes.url_helpers

        delegate :current_user, to: :controller

        def show
          render
        end

        def max_results
          model.settings.max_results
        end

        def highlighted_items
          @highlighted_items ||= highlighted_processes
        end

        def i18n_scope
          "decidim.participatory_processes.pages.home.highlighted_processes"
        end

        def decidim_participatory_processes
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers
        end

        private

        def process_path(process)
          Decidim::ParticipatoryProcesses::Engine.routes.url_helpers.participatory_process_path(process)
        end

        def active_cta_path(process)
          path, params = process_path(process).split("?")

          "#{path}/#{process.active_step.cta_path}" + (params.present? ? "?#{params}" : "")
        end

        def highlighted_processes
          @highlighted_processes ||= begin
            if highlighted_processes_max_results.zero?
              []
            else
              (
                Decidim::ParticipatoryProcesses::HighlightedParticipatoryProcesses.new |
                Decidim::ParticipatoryProcesses::FilteredParticipatoryProcesses.new("active")
              ).query.published.includes([:organization]).limit(highlighted_processes_max_results)
            end
          end
        end

        def highlighted_processes_max_results
          @highlighted_processes_max_results ||= max_results
        end
      end
    end
  end
end
