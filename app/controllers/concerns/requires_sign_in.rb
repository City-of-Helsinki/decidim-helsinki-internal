# frozen_string_literal: true

# Adds new filter params to the searches
module RequiresSignIn
  extend ActiveSupport::Concern

  def permission_class_chain
    [
      CustomPermissions,
      Decidim::Admin::Permissions,
      Decidim::Permissions
    ]
  end
end
