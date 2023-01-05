# frozen_string_literal: true

# This fixes some issues with the core form builder.
module FormBuilderExtensions
  extend ActiveSupport::Concern

  included do
    private

    # Fixes an issue with undefined ProposalLengthValidator
    def length_for_attribute(attribute, type)
      length_validator = find_validator(attribute, ActiveModel::Validations::LengthValidator)
      return length_validator.options[type] if length_validator

      nil
    end
  end
end
