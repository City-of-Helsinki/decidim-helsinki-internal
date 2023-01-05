# frozen_string_literal: true

# Adds the extra fields to the admin categories form.
module AccountFormExtensions
  extend ActiveSupport::Concern

  included do
    attribute :phone, String
    attribute :division, String
    attribute :providing_help, Decidim::Form::Boolean, default: false
    attribute :providing_help_details, String

    # In development environment we can end up in an endless loop if we alias
    # the already overridden method as then it will call itself.
    alias_method :map_model_orig, :map_model unless method_defined?(:map_model_orig)

    def map_model(model)
      map_model_orig(model)

      self.phone = model.extended_data["phone"]
      self.division = model.extended_data["division"]
      self.providing_help = model.extended_data["providing_help"]
      self.providing_help_details = model.extended_data["providing_help_details"]
    end
  end
end
