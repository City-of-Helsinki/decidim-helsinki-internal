# frozen_string_literal: true

# Fixes a bug when the budgets module is not installed
module CommentCellExtensions
  extend ActiveSupport::Concern

  included do
    private

    def commentable_path(params = {})
      resource_locator(root_commentable).path(params)
    end
  end
end
