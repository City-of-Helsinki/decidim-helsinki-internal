# frozen_string_literal: true

module Decidim
  # View helpers related to the layout.
  module LayoutHelper
    # Public: Generates a set of meta tags that generate the different favicon
    # versions for an organization.
    #
    # Returns a safe String with the versions.
    def favicon
      return if current_organization.favicon.blank?
      return unless current_organization.favicon.attached?

      uploader = current_organization.attached_uploader(:favicon)
      safe_join(Decidim::OrganizationFaviconUploader::SIZES.map do |version, size|
        favicon_link_tag(uploader.variant_url(version.to_sym, host: current_organization.host), sizes: "#{size}x#{size}")
      end)
    end

    def apple_favicon
      icon_image = current_organization.attached_uploader(:favicon).variant_url(:medium, host: current_organization.host)
      return unless icon_image

      favicon_link_tag(icon_image, rel: "apple-touch-icon", type: "image/png")
    end

    def legacy_favicon
      icon_image = current_organization.attached_uploader(:favicon).variant_url(:small, host: current_organization.host)
      return unless icon_image

      favicon_link_tag(icon_image.gsub(".png", ".ico"), rel: "icon", sizes: "any", type: nil)
    end

    # Outputs an SVG-based icon.
    #
    # name    - The String with the icon name.
    # options - The Hash options used to customize the icon (default {}):
    #             :width  - The Number of width in pixels (optional).
    #             :height - The Number of height in pixels (optional).
    #             :aria_label - The String to set as aria label (optional).
    #             :aria_hidden - The Truthy value to enable aria_hidden (optional).
    #             :role - The String to set as the role (optional).
    #             :class - The String to add as a CSS class (optional).
    #
    # Returns a String.
    def icon(name, options = {})
      html_properties = {}

      html_properties["width"] = options[:width]
      html_properties["height"] = options[:height]
      html_properties["aria-label"] = options[:aria_label]
      html_properties["role"] = options[:role]
      html_properties["aria-hidden"] = options[:aria_hidden]

      html_properties["class"] = (["icon--#{name}"] + _icon_classes(options)).join(" ")

      if name == "helsinki"
        # Fetch Helsinki icon from the local icon files instead of the main
        # icons.svg so that we don't need to customize the whole icon file.
        html_properties["alt"] = options[:alt] || "Helsinki"

        content_tag :svg, html_properties do
          content_tag :use, nil, "xlink:href" => "#{asset_pack_path("media/images/hkilogo-symbol.svg")}#icon-helsinki"
        end
      else
        content_tag :svg, html_properties do
          content_tag :use, nil, "xlink:href" => "#{asset_pack_path("media/images/icons.svg")}#icon-#{name}"
        end
      end
    end

    # Outputs a SVG icon from an external file. It apparently renders an image
    # tag, but then a JS script kicks in and replaces it with an inlined SVG
    # version.
    #
    # path    - The asset's path
    #
    # Returns an <img /> tag with the SVG icon.
    def external_icon(path, options = {})
      # Ugly hack to prevent PhantomJS from freaking out with SVGs.
      classes = _icon_classes(options) + ["external-icon"]
      return content_tag(:span, "?", class: classes.join(" "), "data-src" => path) if Rails.env.test?

      if path.split(".").last == "svg"
        asset = Rails.application.assets_manifest.find_sources(path).first
        asset.gsub("<svg ", "<svg class=\"#{classes.join(" ")}\" ").html_safe
      else
        image_tag(path, class: classes.join(" "), style: "display: none")
      end
    end

    def _icon_classes(options = {})
      classes = options[:remove_icon_class] ? [] : ["icon"]
      classes += [options[:class]]
      classes.compact
    end

    # Renders a view with the customizable CSS variables in two flavours:
    # 1. as a hexadecimal valid CSS color (ie: #ff0000)
    # 2. as a disassembled RGB components (ie: 255,0,0)
    #
    # Example:
    #
    # --primary: #ff0000;
    # --primary-rgb: 255,0,0
    #
    # Hexadecimal variables can be used as a normal CSS color:
    #
    # color: var(--primary)
    #
    # While the disassembled variant can be used where you need to manipulate
    # the color somehow (ie: adding a background transparency):
    #
    # background-color: rgba(var(--primary-rgb), 0.5)
    def organization_colors
      css = current_organization.colors.each.map { |k, v| "--#{k}: #{v};--#{k}-rgb: #{v[1..2].hex},#{v[3..4].hex},#{v[5..6].hex};" }.join
      render partial: "layouts/decidim/organization_colors", locals: { css: css }
    end
  end
end
