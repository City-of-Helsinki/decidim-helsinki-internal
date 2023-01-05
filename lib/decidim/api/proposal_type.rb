# frozen_string_literal: true

# Needed because of the following bug in core:
# https://github.com/decidim/decidim/pull/7784
module Decidim
  module Proposals
    ProposalType = GraphQL::ObjectType.define do
      name "Proposal"
      description "A proposal"

      field :id, !types.ID
    end
  end
end
