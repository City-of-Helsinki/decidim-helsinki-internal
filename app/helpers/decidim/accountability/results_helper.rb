# frozen_string_literal: true

module Decidim
  module Accountability
    module ResultsHelper
      # Returns a list of available results components with their process names
      # as the labels.
      def available_result_components
        comps = accountability_components.map do |component|
          [translated_attribute(component.participatory_space.title), component.id]
        end

        sort_filter_options(comps)
      end

      def available_statuses
        if respond_to?(:current_component) && current_component
          statuses = Decidim::Accountability::Status.where(component: current_component).map do |status|
            [translated_attribute(status.name), status.key]
          end
          return sort_filter_options(statuses)
        end

        components = accountability_components
        keys = Decidim::Accountability::Status.where(component: components).select(:key).distinct.pluck(:key)

        statuses = keys.map do |key|
          [translated_attribute(Decidim::Accountability::Status.find_by(component: components, key: key).name), key]
        end
        sort_filter_options(statuses)
      end

      def accountability_components
        query = Decidim::Component.where(manifest_name: "accountability").published

        org_tables = []
        Decidim.participatory_space_manifests.each do |space|
          cls = space.model_class_name.constantize
          query = query.joins(
            <<~SQL
              LEFT JOIN #{cls.table_name} ON #{cls.table_name}.id = decidim_components.participatory_space_id
                AND decidim_components.participatory_space_type = #{Arel.sql("'#{cls}'")}
            SQL
          )
          org_tables << cls.table_name
        end
        query.where(
          org_tables.map { |table| "#{table}.decidim_organization_id = #{current_organization.id}" }.join(" OR ")
        )
      end

      def author_information(author)
        [
          author.email,
          author.extended_data["phone"],
          author.extended_data["division"]
        ].compact
      end

      def search_tags
        return [] unless filter.respond_to?(:tag_id)

        Decidim::Tags::Tag.where(organization: current_organization, id: filter.tag_id)
      end

      def sort_filter_options(values)
        values.sort_by { |v| v[0] }
      end
    end
  end
end
