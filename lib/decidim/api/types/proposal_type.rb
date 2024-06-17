# frozen_string_literal: true

# Needed because of the following bug in core:
# https://github.com/decidim/decidim/pull/7784
module Decidim
  module Proposals
    class ProposalType < Decidim::Api::Types::BaseObject
      graphql_name "Proposal"
      description "A proposal"

      field :id, GraphQL::Types::ID
    end
  end
end
