# frozen_string_literal: true

# Needed because of the following bugs in core:
# https://github.com/decidim/decidim/pull/7784
# https://github.com/decidim/decidim/pull/7855
module MeetingExtensions
  extend ActiveSupport::Concern

  included do
    # The core scope depends on assemblies which we do not have installed, so
    # the scope needs to be redefined.
    scope :visible_meeting_for, lambda { |user|
      (all.distinct if user&.admin?) ||
        if user.present?
          spaces = []
          spaces << "assembly" if defined?(Decidim::Assembly)
          spaces << "participatory_process" if defined?(Decidim::ParticipatoryProcess)
          spaces << "conference" if defined?(Decidim::Conference)
          user_role_queries = spaces.map do |participatory_space_name|
            "SELECT decidim_components.id FROM decidim_components
            WHERE CONCAT(decidim_components.participatory_space_id, '-', decidim_components.participatory_space_type)
            IN
            (SELECT CONCAT(decidim_#{participatory_space_name}_user_roles.decidim_#{participatory_space_name}_id, '-Decidim::#{participatory_space_name.classify}')
            FROM decidim_#{participatory_space_name}_user_roles WHERE decidim_#{participatory_space_name}_user_roles.decidim_user_id = ?)
            "
          end

          query = "
            decidim_meetings_meetings.private_meeting = ?
            OR decidim_meetings_meetings.transparent = ?
            OR decidim_meetings_meetings.id IN (
              SELECT decidim_meetings_registrations.decidim_meeting_id FROM decidim_meetings_registrations WHERE decidim_meetings_registrations.decidim_user_id = ?
            )
            OR decidim_meetings_meetings.decidim_component_id IN (
              SELECT decidim_components.id FROM decidim_components
              WHERE CONCAT(decidim_components.participatory_space_id, '-', decidim_components.participatory_space_type)
              IN
                (SELECT CONCAT(decidim_participatory_space_private_users.privatable_to_id, '-', decidim_participatory_space_private_users.privatable_to_type)
                FROM decidim_participatory_space_private_users WHERE decidim_participatory_space_private_users.decidim_user_id = ?)
            )
          "
          if user_role_queries.any?
            query = "#{query} OR decidim_meetings_meetings.decidim_component_id IN
              (#{user_role_queries.compact.join(" UNION ")})
            "
          end

          where(query, false, true, user.id, user.id, *user_role_queries.compact.map { user.id }).distinct
        else
          visible
        end
    }

    def authored_proposals
      []
    end
  end
end
