# frozen_string_literal: true

# Changes functionality in the participatory processes controller:
# - Excludes the process with slug "yleinen"
# - Provides access to the content sections
# - Provides a helper to decide how the participatory processes are displayed
module ParticipatoryProcessesExtensions
  extend ActiveSupport::Concern
  include ParticipatoryProcessesContentSections
  include Decidim::TranslatableAttributes

  included do
    helper MeetingsHelper

    helper_method :translated_content_section, :display_processes_as_cards?

    # Only processes, no groups
    def collection
      @collection ||= participatory_processes
    end

    # Get all processes, not only groupless
    def participatory_processes
      @participatory_processes ||= filtered_processes.where.not(slug: "yleinen")
    end
  end

  private

  def translated_content_section(section_id)
    return unless content_section_contents[section_id]

    translated_attribute(content_section_contents[section_id])
  end

  def display_processes_as_cards?
    return false if filter_params[:date] == "active"
    return false if filter_params[:date] == "upcoming"

    true
  end
end
