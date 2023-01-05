# frozen_string_literal: true

# Overrides the search commands for custom searches.
module SearchOverrides
  extend ActiveSupport::Concern

  included do
    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid, together with the search results.
    # - :invalid if something failed and couldn't proceed.
    #
    # Returns nothing.
    def call
      search_results = searchable_resources.inject({}) do |results_by_type, (class_name, klass)|
        result_ids = filtered_query_for(class_name).pluck(:resource_id)
        results_count = result_ids.count

        results = paginate(klass.order_by_id_list(result_ids))

        results_by_type.update(class_name => {
                                 count: results_count,
                                 results: results,
                                 id: class_name.underscore.gsub("/", "_"),
                                 name: t("search.#{klass.model_name.i18n_key}.name")
                               })
      end
      broadcast(:ok, search_results)
    end

    # In development environment we can end up in an endless loop if we alias
    # the already overridden method as then it will call itself.
    alias_method :filtered_query_for_orig, :filtered_query_for unless method_defined?(:filtered_query_for_orig)

    def filtered_query_for(class_name)
      query = filtered_query_for_orig(class_name)

      return filtered_query_for_user(query) if class_name == "Decidim::User"

      query
    end
  end

  private

  def searchable_resources
    {
      "Decidim::User" => Decidim::User,
      "Decidim::Plans::Plan" => Decidim::Plans::Plan,
      "Decidim::Blogs::Post" => Decidim::Blogs::Post
    }
  end

  def filtered_query_for_user(base)
    query = base.joins(
      "INNER JOIN decidim_users ON decidim_searchable_resources.resource_id = decidim_users.id"
    )
    query = query.where("extended_data->>'providing_help' =?", "true") if filters[:subtype] == "sparring"

    query
  end
end
