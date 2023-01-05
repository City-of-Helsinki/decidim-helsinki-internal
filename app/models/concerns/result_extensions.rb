# frozen_string_literal: true

# Adds the extra fields to results.
module ResultExtensions
  extend ActiveSupport::Concern

  # Public: Returns the attachment context for this record.
  def attachment_context
    :admin
  end
end
