# frozen_string_literal: true

module Decidim
  module Core
    autoload :ScopeTypeType, "decidim/api/types/scope_type_type"
  end

  module ParticipatoryProcesses
    autoload :ParticipatoryProcessTypeExtensions, "decidim/api/types/participatory_process_type_extensions"
  end

  # Needed because of the following bug in core (also plans needs this right now):
  # https://github.com/decidim/decidim/pull/7784
  module Proposals
    autoload :ProposalType, "decidim/api/types/proposal_type"
  end

  module Plans
    module SectionContent
      autoload :LinkProposalsType, "decidim/api/types/link_proposals_type"
    end
  end
end
