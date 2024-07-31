# frozen_string_literal: true

# Adds the extra fields to results.
module ResultExtensions
  extend ActiveSupport::Concern

  # Public: Returns the attachment context for this record.
  def attachment_context
    :admin
  end

  included do
    scope :with_status, ->(status_handle) do
      return self if status_handle.blank?

      joins(:status).where(decidim_accountability_statuses: { key: status_handle })
    end

    def self.ransackable_scopes(_auth_object = nil)
      [:with_category, :with_scope, :with_status]
    end
  end
end
