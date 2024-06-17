# frozen_string_literal: true

module Helsinki
  # This module's job is to extend the API with custom fields needed in the API
  # that are not currently available in the core.
  module QueryExtensions
    # Public: Extends a type with custom fields.
    #
    # type - A GraphQL::BaseType to extend.
    #
    # Returns nothing.
    def self.included(type)
      type.field(
        :scope_types,
        type: [Decidim::Core::ScopeTypeType],
        description: "Lists all scope types",
      ) do
        argument :name, Decidim::Core::ScopeTypeNameFilter, "Provides several methods to order the results", required: false
      end

      type.field :scopes, type: [Decidim::Core::ScopeApiType] do
        description "Lists all scopes"
      end
    end

    def scope_types(name: {})
      query = Decidim::ScopeType.where(organization: context[:current_organization])
      query = query.where("name->>? =?", name[:locale], name[:text]) if name.present?
      query
    end

    def scopes
      Decidim::Scope.where(
        organization: context[:current_organization]
      )
    end
  end
end
