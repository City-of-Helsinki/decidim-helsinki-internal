# frozen_string_literal: true

# Redefines the search fields for users.
module UserExtensions
  extend ActiveSupport::Concern

  include Decidim::HasUploadValidations

  class_methods do
    def redefine_searchable_fields
      @search_resource_indexable_fields = Decidim::SearchResourceFieldsMapper.new(
        organization_id: :decidim_organization_id,
        A: :name,
        D: :providing_help_details,
        datetime: :created_at
      )

      @search_resource_indexable_fields.set_index_condition(:create, ->(user) { !user.deleted? })
      @search_resource_indexable_fields.set_index_condition(:update, ->(user) { !user.deleted? })
    end
  end

  included do
    redefine_searchable_fields
  end

  def providing_help?
    extended_data["providing_help"] ? true : false
  end

  def providing_help_details
    extended_data["providing_help_details"]
  end
end
