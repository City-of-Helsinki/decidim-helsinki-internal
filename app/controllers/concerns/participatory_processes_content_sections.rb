# frozen_string_literal: true

# Provides extra content sections for the participatory processes index page.
module ParticipatoryProcessesContentSections
  extend ActiveSupport::Concern

  private

  def content_section_handles
    @content_section_handles ||= %w(
      participatory_processes_intro
      participatory_processes_phases_intro
      participatory_processes_phases
      participatory_processes_index
      participatory_processes_sparring
    )
  end

  def content_section_contents
    @content_section_contents ||= content_section_handles.map do |section_id|
      [section_id, Decidim::ContextualHelpSection.find_content(current_organization, section_id)]
    end.to_h
  end
end
