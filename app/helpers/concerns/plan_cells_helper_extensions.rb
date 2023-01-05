# frozen_string_literal: true

# Extensions for the Decidim::ScopesHelper
module PlanCellsHelperExtensions
  extend ActiveSupport::Concern

  included do
    def state_classes
      case state
      when "accepted"
        ["success"]
      when "rejected"
        ["alert"]
      when "evaluating"
        ["warning"]
      when "withdrawn"
        ["alert"]
      else
        ["success"]
      end
    end
  end
end
