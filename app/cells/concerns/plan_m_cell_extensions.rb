# frozen_string_literal: true

module PlanMCellExtensions
  extend ActiveSupport::Concern

  included do
    def has_badge?
      true
    end

    def has_state?
      true
    end

    def has_tags?
      true
    end

    def needs_help?
      return false unless needs_help_content

      needs_help_content.body["value"] == true
    end
  end

  def needs_help_section
    @needs_help_section ||= section_with_handle("sparring")
  end

  def needs_help_content
    @needs_help_content ||= content_for(needs_help_section)
  end
end
