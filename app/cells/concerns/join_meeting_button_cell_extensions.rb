# frozen_string_literal: true

module JoinMeetingButtonCellExtensions
  extend ActiveSupport::Concern

  included do
    def button_classes
      return "button hollow" if big_button?

      "button card__button hollow"
    end
  end
end
