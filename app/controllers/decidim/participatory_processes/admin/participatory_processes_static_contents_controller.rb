# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      class ParticipatoryProcessesStaticContentsController < Decidim::Admin::ApplicationController
        include Decidim::Admin::ParticipatorySpaceAdminContext
        include Decidim::TranslationsHelper
        include ParticipatoryProcessesContentSections

        layout "decidim/admin/participatory_processes"

        helper_method :sections

        before_action do
          enforce_permission_to :update, :help_sections
        end

        def show
          @form = form(Decidim::Admin::HelpSectionsForm).from_model(
            OpenStruct.new(sections: sections)
          )
        end

        def update
          @form = form(Decidim::Admin::HelpSectionsForm).from_params(
            params[:help_sections]
          )

          Decidim::Admin::UpdateHelpSections.call(@form, current_organization) do
            on(:ok) do
              flash[:notice] = t("help_sections.success", scope: "decidim.admin")
              redirect_to action: :show
            end

            on(:invalid) do
              flash.now[:alert] = t("help_sections.error", scope: "decidim.admin")
            end
          end
        end

        private

        def current_participatory_space; end

        def sections
          @sections ||= content_section_contents.map do |section_id, content|
            OpenStruct.new(
              id: section_id,
              content: content
            )
          end
        end
      end
    end
  end
end
