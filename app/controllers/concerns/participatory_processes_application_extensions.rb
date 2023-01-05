# frozen_string_literal: true

# Sets the needed permissions to the permissions chain.
module ParticipatoryProcessesApplicationExtensions
  extend ActiveSupport::Concern

  included do
    register_permissions(
      Decidim::ParticipatoryProcesses::ApplicationController,
      ::Decidim::ParticipatoryProcesses::Permissions,
      ::Decidim::Plans::Permissions,
      ::Decidim::Admin::Permissions,
      ::Decidim::Permissions
    )
  end
end
