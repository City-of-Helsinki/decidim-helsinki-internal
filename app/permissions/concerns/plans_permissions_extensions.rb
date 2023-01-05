# frozen_string_literal: true

module PlansPermissionsExtensions
  extend ActiveSupport::Concern

  included do
    def can_read_plan?
      toggle_allow(user.present?)
    end

    def can_read_plans?
      toggle_allow(user.present?)
    end

    def can_withdraw_plan?
      return unless plan.present?
      return if plan.withdrawn?
      return toggle_allow(true) if user.admin?

      toggle_allow(plan && plan.withdrawable_by?(user))
    end
  end
end
