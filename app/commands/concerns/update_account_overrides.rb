# frozen_string_literal: true

# Overrides the update user command to add the extra data on the form.
module UpdateAccountOverrides
  extend ActiveSupport::Concern

  included do
    def update_personal_data
      @user.name = @form.name
      @user.nickname = Decidim::UserBaseEntity.nicknamize(@user.name, organization: @form.current_organization)
      @user.email = @form.email
    end
  end
end
