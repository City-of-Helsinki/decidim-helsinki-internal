# frozen_string_literal: true

module Decidim
  module Accountability
    # This class handles search and filtering of results. Needs a
    # `current_component` param with a `Decidim::Component` in order to
    # find the results.
    class ResultSearch < ResourceSearch
      # Public: Initializes the service.
      #
      # options - A hash of options to modify the search. These options will be
      #          converted to methods by SearchLight so they can be used on filter
      #          methods. (Default {})
      #          * component - A Decidim::Component to get the results from.
      #          * organization - A Decidim::Organization object.
      #          * parent_id - The parent ID of the result. The value is forced to false to force
      #                        the filter execution when the value is nil
      #          * deep_search - Whether to perform the search on all children levels or just the
      #                          first one. True by default.
      def initialize(options = {})
        options = options.dup
        options[:deep_search] = true if options[:deep_search].nil?
        options[:parent_id] = "root" if options[:parent_id].nil?
        super(Result.all, options)
      end

      # Creates the SearchLight base query.
      # Check if the option component was provided.
      def base_query
        if component || options[:component_id]
          query = @scope.joins(:component).where.not(decidim_components: { published_at: nil })
          return query.where(component: component) if component

          return query.where(component: options[:component_id])
        end

        # Not inside a component, so filter from all components within the
        # organization. PublishedResourceFetcher only fetches from the results
        # that are in published spaces and components. The last `.published`
        # filter filters the published results only.
        PublishedResourceFetcher.new(@scope, organization).query.published
      end

      # Handle the search_text filter
      def search_search_text
        search_query = query.left_outer_joins(:tags, :attachments, :result_detail_values, :result_links)

        search_query
          .where(localized_search_text_in(:title), text: "%#{search_text}%")
          .or(search_query.where(localized_search_text_in(:description), text: "%#{search_text}%"))
          .or(search_query.where(localized_search_text_in(:name, :decidim_tags_tags), text: search_text))
          .or(search_query.where(localized_search_text_in(:title, :decidim_attachments), text: "%#{search_text}%"))
          .or(search_query.where(localized_search_text_in(:description, :decidim_accountability_simple_result_detail_values), text: "%#{search_text}%"))
          .or(search_query.where(localized_search_text_in(:label, :decidim_accountability_simple_result_links), text: "%#{search_text}%"))
      end

      # Handle parent_id filter
      def search_parent_id
        parent_id = options[:parent_id]
        parent_id = nil if parent_id == "root"

        if options[:deep_search]
          query.where(parent_id: [parent_id] + children_ids(parent_id))
        else
          query.where(parent_id: parent_id)
        end
      end

      def search_status
        return unless options[:status].present?

        query.joins(:status).where(decidim_accountability_statuses: { key: options[:status] })
      end

      def search_tag_id
        return query unless tag_id.is_a? Array

        # Fetch the result IDs as a separate query in order to avoid duplicate
        # entries in the final result. We could also use `.distinct` on the
        # main query but that would limit what the user could further on do with
        # that query. Therefore, in this context it is safer to just fetch these
        # in a completely separate query.
        result_ids = Result.joins(:tags).where(
          decidim_tags_tags: { id: tag_id }
        ).distinct.pluck(:id)

        query.where(id: result_ids)
      end

      private

      def children_ids(parent_id)
        Result.where(parent_id: parent_id).pluck(:id)
      end

      # Internal: builds the needed query to search for a text in the organization's
      # available locales. Note that it is intended to be used as follows:
      #
      # Example:
      #   Resource.where(localized_search_text_for(:title, text: "my_query"))
      #
      # The Hash with the `:text` key is required or it won't work.
      def localized_search_text_in(field, table = :decidim_accountability_results)
        options[:organization].available_locales.map do |l|
          "#{table}.#{field} ->> '#{l}' ILIKE :text"
        end.join(" OR ")
      end
    end
  end
end
