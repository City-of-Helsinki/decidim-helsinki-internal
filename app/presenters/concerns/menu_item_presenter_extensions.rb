# frozen_string_literal: true

# Needed to add the aria-current attribute to the current menu item.
module MenuItemPresenterExtensions
  extend ActiveSupport::Concern

  included do
    def render
      content_tag :li, class: link_wrapper_classes do
        if icon_name
          link_to(url, link_options) { icon(icon_name) + label }
        else
          link_to label, url, link_options
        end
      end
    end
  end

  private

  def link_options
    if is_active_link?(url, active)
      { aria: { current: "page" } }
    else
      {}
    end
  end
end
