# frozen_string_literal: true

# Controller for the static plain content pages.
class ContentPagesController < Decidim::ApplicationController
  before_action :set_page

  helper_method :custom_locale

  def show
    @title = @page[:title]
    @content = @page[:content]
  end

  private

  def set_page
    @page = Rails.application.config.static_content_pages[params[:id]]

    raise AbstractController::ActionNotFound, "No page was found at #{params[:id]}" unless @page
  end

  def custom_locale
    @custom_locale = @page[:locale]
  end
end
