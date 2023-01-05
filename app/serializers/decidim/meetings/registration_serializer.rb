# frozen_string_literal: true

# This override is needed to properly export the user answers to a form when
# the form has single or multiple choice questions with the "free text" enabled
# for them. In this case, the free text answers were not correctly exported.
#
# Can be removed after the following PR is merged:
# https://github.com/decidim/decidim/pull/7892
module Decidim
  module Meetings
    class RegistrationSerializer < Decidim::Exporters::Serializer
      include Decidim::TranslationsHelper
      # Serializes a registration
      def serialize
        {
          id: resource.id,
          code: resource.code,
          user: {
            name: resource.user.name,
            email: resource.user.email,
            user_group: resource.user_group&.name || ""
          },
          registration_form_answers: serialize_answers
        }
      end

      private

      def serialize_answers
        Decidim::Forms::UserAnswersSerializer.new(
          resource.meeting.questionnaire.answers.where(user: resource.user)
        ).serialize
      end
    end
  end
end
