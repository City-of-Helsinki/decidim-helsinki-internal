# frozen_string_literal: true

module PlanFormCellExtensions
  extend ActiveSupport::Concern

  included do
    def display_save_as_draft?
      false
    end
  end
end
