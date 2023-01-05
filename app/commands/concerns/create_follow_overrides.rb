# frozen_string_literal: true

# Fixes a bug with the CreateFollow command that causes a validation error in
# case the user is already following the record. This can happen e.g. when
# the user signs up for the event, then cancels and then signs up again.
module CreateFollowOverrides
  extend ActiveSupport::Concern

  included do
    def create_follow!
      @follow = Decidim::Follow.find_by(
        followable: form.followable,
        user: current_user
      ) || Decidim::Follow.create!(
        followable: form.followable,
        user: current_user
      )
    end
  end
end
