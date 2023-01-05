# frozen_string_literal: true

module Decidim
  # This controller serves static pages using HighVoltage.
  class PagesController < Decidim::ApplicationController
    layout "layouts/decidim/application"

    helper_method :page, :pages, :infos_page?, :target_path
    helper CtaButtonHelper
    helper Decidim::SanitizeHelper

    before_action :set_default_request_format

    def index
      enforce_permission_to :read, :public_page

      if infos_page?
        @topics = []
        @orphan_pages = Decidim::StaticPage.where(topic: nil, organization: current_organization)
      else
        @topics = Decidim::StaticPageTopic.where(organization: current_organization)
        @orphan_pages = []
      end
    end

    def show
      @page = current_organization.static_pages.find_by!(slug: params[:id])
      if infos_page?
        return redirect_to page_path(@page) if @page.topic
      else
        return redirect_to main_app.info_path(@page) unless @page.topic
      end

      enforce_permission_to :read, :public_page, page: @page
      @topic = @page.topic
      @pages = @topic&.pages
    end

    private

    def set_default_request_format
      request.format = :html
    end

    def infos_page?
      @infos_page ||= request.path.start_with?(main_app.infos_path)
    end

    def target_path(page)
      if infos_page?
        main_app.info_path(page)
      else
        page_path(page)
      end
    end
  end
end
