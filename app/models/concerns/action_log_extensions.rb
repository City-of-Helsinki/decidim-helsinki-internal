# frozen_string_literal: true

# Adds the extra fields to blog posts.
module ActionLogExtensions
  extend ActiveSupport::Concern

  included do
    def self.public_resource_types
      @public_resource_types ||= %w(
        Decidim::Accountability::Result
        Decidim::Blogs::Post
        Decidim::Comments::Comment
        Decidim::Debates::Debate
        Decidim::Meetings::Meeting
        Decidim::Surveys::Survey
        Decidim::ParticipatoryProcess
        Decidim::Plans::Plan
      ).select do |klass|
        klass.safe_constantize.present?
      end
    end
  end
end
