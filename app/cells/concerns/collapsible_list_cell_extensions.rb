# frozen_string_literal: true

# Adds new functionality to the collapsible cells not to display the more/less
# links that are problematic when the whole cards are links.
module CollapsibleListCellExtensions
  extend ActiveSupport::Concern

  # included do
  #   def collapsible?
  #     !limited? && list.size > size
  #   end
  # end

  def limited?
    options[:limited]
  end
end
