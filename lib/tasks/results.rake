# frozen_string_literal: true

require "zip"
require "nokogiri"
require "tempfile"

namespace :results do
  # Export result reports with their attachments as a single ZIP package.
  #
  # Usage: rake results:export[1,tmp/results.zip]
  desc "Export result reports."
  task :export, [:organization_id, :filename] => [:environment] do |_t, args|
    $stdout.sync = true

    organization = Decidim::Organization.find_by(id: args.organization_id)
    unless organization
      puts "Invalid organization ID: #{args.organization_id}"
      next
    end
    if File.exist?(args.filename)
      puts "File already exists: #{args.filename}"
      next
    end

    space_components = Decidim::Component.none
    Decidim.participatory_space_manifests.each do |manifest|
      spaces = manifest.participatory_spaces.call(organization)
      space_components = space_components.or(
        Decidim::Component.where(
          participatory_space_type: manifest.model_class_name,
          participatory_space_id: spaces
        )
      )
    end
    components = Decidim::Component.where(manifest_name: "accountability").merge(space_components)

    # Force unicode names for the scandinavian characters to be encoded
    # correctly within the ZIP archive.
    Zip.setup do |config|
      config.unicode_names = true
    end

    locale = organization.default_locale
    tempfiles = []
    Zip::File.open(args.filename, Zip::File::CREATE) do |zipfile|
      I18n.with_locale(locale) do
        Decidim::Accountability::Result.where(component: components).order(:id).each do |result|
          root_result = result
          root_result = root_result.parent while root_result.parent

          slug = translated_attribute(result.title).parameterize
          puts "Exporting result with ID: #{result.id} (#{slug})"

          details = result.result_all_details.to_h do |detail|
            next [detail.id, nil] if translated_attribute(detail.description_for(result)).empty?

            [
              translated_attribute(detail.title),
              translated_attribute(detail.description_for(result))
            ]
          end.compact

          if root_result.scope
            title =
              if root_result.scope.parent
                translated_attribute(root_result.scope.parent.name)
              else
                I18n.t("results.show.stats.scope", scope: "decidim.accountability")
              end

            details[title] = translated_attribute(root_result.scope.name)
          end
          if root_result.category
            details[I18n.t("results.show.stats.category", scope: "decidim.accountability")] = translated_attribute(root_result.category.name)
          end

          result_dir = "#{result.id}-#{slug}"
          attachments_dir = "#{result_dir}/attachments"
          images_dir = "#{result_dir}/images"

          zipfile.mkdir(result_dir)
          zipfile.mkdir(attachments_dir)
          zipfile.mkdir(images_dir)

          images = {}
          if result.main_image && result.main_image.attached?
            filename = result.main_image.blob.filename.to_s
            tempfile = Tempfile.new([File.basename(filename, ".*"), File.extname(filename)])
            tempfile.binmode
            begin
              tempfile.write(result.main_image.blob.download)
              tempfile.rewind
              tempfiles << tempfile
              zipfile.add("#{images_dir}/#{zip_filename(filename)}", tempfile.path)
              images[:main_image] = "./images/#{filename}"
            rescue ActiveStorage::FileNotFoundError
              puts "File not found for blob ID: #{result.main_image.blob.id}"
              tempfile.close
              tempfile.unlink
            end
          end

          docs = result.documents.to_h do |document|
            next [document.id, nil] unless document.file.attached?

            filename = "#{document.id}-#{document.file.blob.filename}"
            tempfile = Tempfile.new([File.basename(filename, ".*"), File.extname(filename)])
            tempfile.binmode
            begin
              tempfile.write(document.file.blob.download)
              tempfile.rewind
              tempfiles << tempfile
              zipfile.add("#{attachments_dir}/#{zip_filename(filename)}", tempfile.path)
            rescue ActiveStorage::FileNotFoundError
              puts "File not found for blob ID: #{document.file.blob.id}"
              tempfile.close
              tempfile.unlink

              next [document.id, nil]
            end

            [document.id, "./attachments/#{filename}"]
          end.compact

          builder = Nokogiri::HTML5::Builder.new do |html|
            html.text "\n"
            html.html(lang: locale) do
              html.head do
                html.title [translated_attribute(result.title), organization.name].join(" - ")
              end
              html.body do
                html.h1 translated_attribute(result.title)
                if images[:main_image].present?
                  html.p do
                    html.img src: images[:main_image], alt: translated_attribute(result.title), style: "max-width:800px;"
                  end
                end
                html.hr
                html.div class: "details" do
                  details.each do |title, desc|
                    html.h2 title
                    html.p desc
                  end
                  html.h2 "Avainsanat"
                  html.ul do
                    result.tags.each do |tag|
                      html.li translated_attribute(tag.name)
                    end
                  end
                  if result.documents.any?
                    html.h2 "Liitteet"
                    # Without collection
                    html.ul do
                      result.documents.reject(&:attachment_collection_id?).each do |doc|
                        path = docs[doc.id]
                        next unless path

                        html.li do
                          html.a document_title(doc), href: path
                        end
                      end
                    end
                    # With collection
                    result.documents.select(&:attachment_collection_id?).group_by(&:attachment_collection).sort_by { |c, d| c.weight }.each do |collection, documents|
                      html.h3 translated_attribute(collection.name)

                      html.ul do
                        documents.each do |doc|
                          path = docs[doc.id]
                          next unless path

                          html.li do
                            html.a document_title(doc), href: path
                          end
                        end
                      end
                    end
                  end
                  if result.result_links.any?
                    html.h2 "Linkit"
                    html.ul do
                      result.result_links.each do |link|
                        html.li do
                          html.a translated_attribute(link.label), href: translated_attribute(link.url), target: "_blank"
                        end
                      end
                    end
                  end
                  if result.authors.any?
                    html.h2 "Tekijät"
                    html.ul do
                      result.authors.map do |author|
                        html.li "#{author.name}, #{author.email}"
                      end
                    end
                  end
                end
                html.hr
                html.div class: "content" do
                  html << translated_attribute(result.description)
                end
              end
            end
          end

          indent_html(builder.doc.at_css("html"))

          zipfile.get_output_stream("#{result_dir}/index.html") do |f|
            f.write(builder.to_html)
          end
        end
      end
    end

    puts "Deleting temp files..."
    tempfiles.each do |tempfile|
      tempfile.close
      tempfile.unlink
    end

    puts "All results exported to: #{args.filename}"
  end

  # Filename that works with special characters across different operating
  # systems.
  def zip_filename(filename)
    # filename.encode("CP850", invalid: :replace, undef: :replace, replace: "?")
    filename.encode("UTF-8")
  end

  def translated_attribute(attribute)
    value =
      if attribute.is_a?(Hash)
        attribute[I18n.locale.to_s] || attribute.values.first
      else
        attribute.to_s
      end

    value.strip
  end

  def document_title(document)
    "#{translated_attribute(document.title)} (#{document.file_type}, #{helpers.number_to_human_size(document.file_size)})"
  end

  def indent_html(node, level: 0, spaces: 2)
    children = node.children.to_a
    return if children.any? { |child| child.text? && !child.text.strip.empty? }

    children.each do |child|
      next unless child.element? || child.comment?

      child_level =
        if child.element? && %w(head body).include?(child.name)
          0
        else
          level + 1
        end

      child.add_previous_sibling(
        node.document.create_text_node(
          "\n#{" " * (child_level * spaces)}"
        )
      )

      indent_html(child, level: child_level, spaces: spaces) if child.element?
    end

    if node.element? && !children.empty?
      node.add_child(
        node.document.create_text_node(
          "\n#{" " * (level * spaces)}"
        )
      )
    end
  end

  def helpers
    @helpers ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
