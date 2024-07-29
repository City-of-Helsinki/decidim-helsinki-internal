# frozen_string_literal: true

module Decidim
  module Core
    # This type represents an ScopeType.
    class ScopeTypeType < Decidim::Api::Types::BaseObject
      graphql_name "ScopeType"
      description "A scope type"

      field :id, GraphQL::Types::ID, "The scope type's unique ID", null: false
      field :name, Decidim::Core::TranslatedFieldType, "The name of this scope type.", null: false
      field :plural, Decidim::Core::TranslatedFieldType, "The plural format of this scope type.", null: false
      field :scopes,
            type: [Decidim::Core::ScopeApiType],
            null: true,
            description: "Scopes with this scope type."

      def scopes
        object.scopes.where(
          organization: context[:current_organization],
          parent_id: nil
        )
      end
    end

    class ScopeTypeNameFilter < Decidim::Core::BaseInputFilter
      argument :locale,
                type: GraphQL::Types::String,
                description: "The locale in which to search the name",
                required: true
      argument :text,
                type: GraphQL::Types::String,
                description: "The text to search",
                required: true
    end
  end
end
