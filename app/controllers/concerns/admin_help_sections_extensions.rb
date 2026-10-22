# frozen_string_literal: true

# Adds an extra help section in order to store and display the
module AdminHelpSectionsExtensions
  extend ActiveSupport::Concern

  included do
    private

    def sections
      @sections ||= Decidim.participatory_space_manifests.map do |manifest|
        OpenStruct.new(
          id: manifest.name.to_s,
          content: Decidim::ContextualHelpSection.find_content(current_organization, manifest.name)
        )
      end + extra_help_sections
    end
  end

  def extra_help_sections
    sections = %w(
      help_index
      info_index
      footer_text
      participatory_processes_intro
      participatory_processes_phases_intro
      participatory_processes_phases
      participatory_processes_index
      participatory_processes_sparring
    ).map do |name|
      OpenStruct.new(
        id: name,
        content: Decidim::ContextualHelpSection.find_content(current_organization, name)
      )
    end
  end
end
