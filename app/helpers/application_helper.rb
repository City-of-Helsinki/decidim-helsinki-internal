# frozen_string_literal: true

module ApplicationHelper
  include Decidim::Plans::LinksHelper
  include KoroHelper

  def page_locale
    return custom_locale if respond_to?(:custom_locale)

    current_locale
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/BlockNesting
  def breadcrumbs
    links = []
    links << { title: t("decidim.menu.home"), url: decidim.root_path }
    if respond_to?(:current_participatory_space) && current_participatory_space.present?
      links << {
        title: t("decidim.menu.processes"),
        url: decidim_participatory_processes.participatory_processes_path
      }
      links << {
        title: translated_attribute(current_participatory_space.title),
        url: decidim_participatory_processes.participatory_process_path(current_participatory_space)
      }
      if respond_to?(:current_component)
        links << {
          title: translated_attribute(current_component.name),
          url: main_component_path(current_component)
        }

        if controller.is_a?(Decidim::Meetings::RegistrationsController)
          case action_name
          when "show", "answer"
            links << {
              title: translated_attribute(questionnaire_for.title),
              url: resource_locator(questionnaire_for).path
            }
            links << {
              title: translated_attribute(questionnaire.title),
              url: join_meeting_registration_path(questionnaire_for)
            }
          end
        elsif controller.is_a?(Decidim::Plans::VersionsController)
          links << {
            title: translated_attribute(item.title),
            url: resource_locator(item).path
          }
          links << {
            title: t("decidim.plans.versions.index.title"),
            url: plan_versions_path(item)
          }

          if action_name == "show"
            idx = item.versions.find_index { |v| v.id == current_version.id } + 1
            links << {
              title: t("decidim.plans.versions.version.version_index", index: idx),
              url: plan_version_path(item, idx)
            }
          end
        elsif action_name == "show"
          case controller
          when Decidim::Blogs::PostsController
            links << {
              title: translated_attribute(post.title),
              url: resource_locator(post).path
            }
          when Decidim::Meetings::MeetingsController
            links << {
              title: translated_attribute(meeting.title),
              url: resource_locator(meeting).path
            }
          when Decidim::Plans::PlansController
            links << {
              title: translated_attribute(@plan.title),
              url: resource_locator(@plan).path
            }
          when Decidim::Accountability::ResultsController
            parent = result.parent
            while parent
              links << {
                title: translated_attribute(parent.title),
                url: resource_locator(parent).path
              }
              parent = parent.parent
            end
            links << {
              title: translated_attribute(result.title),
              url: resource_locator(result).path
            }
          end
        elsif action_name == "new"
          case controller
          when Decidim::Plans::PlansController
            links << {
              title: t("decidim.plans.plan_index.new_plan"),
              url: new_plan_path
            }
          end
        elsif action_name == "edit"
          case controller
          when Decidim::Plans::PlansController
            links << {
              title: t("decidim.plans.plans.edit.title"),
              url: edit_plan_path(@plan)
            }
          end
        end
      elsif controller.is_a?(Decidim::ParticipatoryProcesses::ParticipatoryProcessStepsController)
        links << {
          title: t("decidim.participatory_process_steps.index.process_steps"),
          url: decidim_participatory_processes.participatory_process_participatory_process_steps_path(
            current_participatory_space
          )
        }
      end
    elsif controller.is_a?(Decidim::ParticipatoryProcesses::ParticipatoryProcessesController)
      links << { title: t("decidim.menu.processes"), url: decidim_participatory_processes.participatory_processes_path }
    elsif controller.is_a?(Decidim::PagesController) || controller.is_a?(Decidim::Pages::ApplicationController)
      links <<
        if infos_page?
          { title: t("decidim.pages.index.infos_title"), url: main_app.infos_path }
        else
          { title: t("decidim.pages.index.title"), url: decidim.pages_path }
        end
      if @page
        if @page.topic
          links << {
            title: translated_attribute(@page.topic.title),
            url: decidim.page_path(@page.topic.pages.first)
          }
        end
        links << {
          title: translated_attribute(@page.title),
          url: decidim.page_path(@page)
        }
      end
    elsif controller.is_a?(Decidim::Favorites::FavoritesController)
      links << { title: t("decidim.favorites.favorites.show.title"), url: decidim_favorites.favorites_path }
      if @type
        links << {
          title: @type[:name],
          url: decidim_favorites.favorite_path(@selected_type)
        }
      end
    end

    links.last[:current] = true

    links
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/BlockNesting

  def display_header_koro?
    return false if flash.any?

    controller.controller_name != "homepage"
  end

  # Replace the footer koro with a custom one. E.g. a specific background color
  # may need to be added to the footer koro element depending on the previous
  # element.
  def replace_footer_koro(extra_cls)
    content_for :footer_koro, flush: true do
      koro("basic", class: extra_cls).html_safe
    end
  end

  def meta_image_default
    asset_pack_path(Rails.application.config.meta_image)
  end

  def feedback_email
    Rails.application.config.feedback_email
  end
end
