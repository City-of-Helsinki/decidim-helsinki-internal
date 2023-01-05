# frozen_string_literal: true

module Decidim
  module Core
    # This interface represents a categorizable object.
    #
    # THIS IS OVERRIDDEN TO MAKE THE CATEOGORY FIELD OPTIONAL INSTEAD OF
    # REQUIRED. THIS SHOULD BE ALREADY FIXED IN NEWER DECIDIM VERSIONS.
    CategorizableInterface = GraphQL::InterfaceType.define do
      name "CategorizableInterface"
      description "An interface that can be used in categorizable objects."

      field :category, Decidim::Core::CategoryType, "The object's category"
    end
  end
end
