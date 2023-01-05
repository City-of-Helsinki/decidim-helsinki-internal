# frozen_string_literal: true

module Decidim
  module Blogs
    module PostsHelper
      include Decidim::ApplicationHelper
      include Decidim::TranslationsHelper
      include Decidim::ResourceHelper

      # Public: truncates the post body
      #
      # post - a Decidim::Blog instance
      # max_length - a number to limit the length of the body
      #
      # Returns the post's body truncated.
      def post_description(post, max_length = 600)
        link = post_path(post)
        body = translated_attribute(post.body)
        tail = "... <br/> #{link_to(t("read_more", scope: "decidim.blogs"), link)}".html_safe
        CGI.unescapeHTML html_truncate(body, max_length: max_length, tail: tail)
      end

      # Returns a list of available results components with their process names
      # as the labels.
      def available_blog_components
        comps = blogs_components.map do |component|
          [translated_attribute(component.participatory_space.title), component.id]
        end

        sort_filter_options(comps)
      end

      def blogs_components
        query = Decidim::Component.where(manifest_name: "blogs").published

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

      def sort_filter_options(values)
        values.sort_by { |v| v[0] }
      end
    end
  end
end
