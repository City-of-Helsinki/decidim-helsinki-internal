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
  end
end
