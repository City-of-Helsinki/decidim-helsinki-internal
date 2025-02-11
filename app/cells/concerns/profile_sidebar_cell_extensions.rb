# frozen_string_literal: true

module ProfileSidebarCellExtensions
  extend ActiveSupport::Concern

  included do
    private

    def can_contact_user?
      false
    end
  end
end
