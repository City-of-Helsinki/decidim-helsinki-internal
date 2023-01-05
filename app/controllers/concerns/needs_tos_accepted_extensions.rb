# frozen_string_literal: true

module NeedsTosAcceptedExtensions
  extend ActiveSupport::Concern

  included do
    def tos_path
      main_app.info_path terms_and_conditions_page.slug
    end
  end
end
