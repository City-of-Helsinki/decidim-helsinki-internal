# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # Decidim returns all possible categories in the `:categories` field since
    # it's designed to return all the categories for that object. The backoffice
    # software wants to get the categories in a hierarchical way, so this
    # exposes an alternative field for getting the top categories only.
    module ParticipatoryProcessTypeExtensions
      def self.included(type)
        type.field :top_categories, [Decidim::Core::CategoryType], "Top-level categories for this participatory process", null: false
      end

      def top_categories
        object.categories.first_class
      end
    end
  end
end
