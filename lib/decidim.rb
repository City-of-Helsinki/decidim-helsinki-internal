# frozen_string_literal: true

# Needed to make the API work
module Decidim
  def self.version
    Decidim::Core.version
  end
end
