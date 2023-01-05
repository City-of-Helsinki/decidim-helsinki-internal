# frozen_string_literal: true

# Overrides the update user command to add the extra data on the form.
module UpdateAccountOverrides
  extend ActiveSupport::Concern

  included do
    def update_personal_data
      @user.name = @form.name
      @user.nickname = @form.nickname
      @user.email = @form.email
      @user.personal_url = @form.personal_url
      @user.about = @form.about
      @user.extended_data = extended_data
    end

    def extended_data
      @extended_data ||= (@user&.extended_data || {}).merge(
        phone: @form.phone,
        division: @form.division,
        providing_help: @form.providing_help,
        providing_help_details: @form.providing_help_details
      )
    end
  end
end
