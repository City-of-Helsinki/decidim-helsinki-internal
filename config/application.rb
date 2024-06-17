# frozen_string_literal: true

require_relative "boot"

# Rails
require "decidim/rails"
# Add the frameworks used by your app that are not loaded by Decidim.
require "action_cable/engine"

# Other
require "cldr"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimHelsinki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.application_name = "Kokeilukiihdyttämö"
    config.application_beta = true

    # Configure an application wide address suffix to pass to the geocoder.
    # This is to make sure that the addresses are not incorrectly mapped outside
    # of the wanted area.
    config.address_suffix = "Helsinki, Finland"

    # Sending address for mails
    config.mailer_sender = "no-reply@kokeilukiihdyttamo.hel.fi"

    # The default meta image for social media
    config.meta_image = "media/images/social-kokeilukiihdyttamo-wide.jpg"

    # Static language pages if the site content is not fully translated
    config.static_languages = {
      en: "/en",
      sv: "/sv"
    }
    config.static_content_pages = {
      en: {
        locale: "en",
        path: "/en",
        title: "English Summary",
        content: <<~HTML.strip
          <p>
            Kokeilukiihdyttämö (“experimentation accelerator”) helps City of Helsinki employees to plan and execute
            rapid experiments in order to learn more about possibilities of new digital technologies in daily work.
            Kokeilukiihdyttämö was started as part of
            <a href="https://digi.hel.fi/english/" target="_blank">Helsinki’s digitalization programme.</a>.
          </p>
          <p>
            Kokeilukiihdyttämö’s website is mostly in Finnish. Website has information about experimentation support
            campaigns, experiment results, resources, tools and platforms.
          </p>
          <p>
            If you want you can visit our Experimentation gallery through a link using
            <a href="https://kokeilukiihdyttamo-hel-fi.translate.goog/results?_x_tr_sl=fi&_x_tr_tl=en&_x_tr_hl=fi&_x_tr_pto=wapp" target="_blank">
              Google Translate from Finnish to English
            </a>. In the gallery you can browse through our experiments and their results in a nutshell.
          </p>
          <p>
            If you need more information you can contact
            <a href="mailto:kokeilukiihdyttamo@hel.fi">kokeilukiihdyttamo@hel.fi</a>, or Mr. Ville Meloni, tel.
            <a href="tel:+358400260000">+358 400 260 000</a>, <a href="mailto:ville.meloni@hel.fi">ville.meloni@hel.fi</a>.
          </p>
        HTML
      },
      sv: {
        locale: "sv",
        path: "/sv",
        title: "Svenska sammandrag",
        content: <<~HTML.strip
          <p>
            Kokeilukiihdyttämö (”experimentaccelerator”) hjälper anställda i Helsingfors att planera och genomföra
            snabba experiment för att lära sig mer om möjligheterna med ny digital teknik i det dagliga arbetet.
            Kokeilukiihdyttämö är en del av
            <a href="https://digi.hel.fi/svenska/" target="_blank">Helsingfors digitaliseringsprogram</a>.
          </p>
          <p>
            Kokeilukiihdyttämö webbplats är mestadels på finska. Webbplatsen har information om experimentstödkampanjer,
            resurser, verktyg och plattformar.
          </p>
          <p>
            Om du behöver mer information, du kan ta kontakt vid
            <a href="mailto:kokeilukiihdyttamo@hel.fi">kokeilukiihdyttamo@hel.fi</a> eller direkt till projektchef
            Ville Meloni, tel. +358 400 260 000.
          </p>
        HTML
      }
    }

    # Tracking
    config.matomo_site_id = nil

    # Can the site be indexed by search engines
    config.search_indexing = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add the override translations to the load path
    config.i18n.load_path += Dir[
      Rails.root.join("config", "locales", "overrides/*.yml").to_s,
    ]

    # Add extra asset paths
    # config.assets.paths += Dir[
    #   Rails.root.join("app", "assets", "fonts").to_s,
    # ]

    # Wrapper class can be used to customize the coloring of the platform per
    # environment. This is used mainly for the Ideapaahtimo/KuVa instance.
    config.wrapper_class = "wrapper-default"

    # The feedback email in the footer of the site
    config.feedback_email = "kokeilukiihdyttamo@hel.fi"

    initializer "graphql_api" do
      Decidim::ParticipatoryProcesses::ParticipatoryProcessType.include(Decidim::ParticipatoryProcesses::ParticipatoryProcessTypeExtensions)

      Decidim::Api::QueryType.include Helsinki::QueryExtensions
    end

    initializer "decidim.core.homepage_content_blocks" do
      # Modify the hero block
      hero = Decidim.content_blocks.for(:homepage).find { |cb| cb.name == :hero }
      if hero
        hero.cell = "helsinki/content_blocks/hero"
        hero.settings_form_cell = "helsinki/content_blocks/hero_settings_form"

        hero.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :subtitle, type: :text, translated: true
          settings.attribute :welcome_text, type: :string, translated: true, editor: true
          settings.attribute :button_url, type: :text
          settings.attribute :button_text, type: :text, translated: true
        end
      end

      Decidim.content_blocks.register(:homepage, :intro) do |content_block|
        content_block.cell = "helsinki/content_blocks/intro"
        content_block.settings_form_cell = "helsinki/content_blocks/intro_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.intro.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :link_url, type: :text
          settings.attribute :link_text, type: :text, translated: true
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :help_section) do |content_block|
        content_block.cell = "helsinki/content_blocks/help_section"
        content_block.settings_form_cell = "helsinki/content_blocks/help_section_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.help_section.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button1_url, type: :text
          settings.attribute :button1_text, type: :text, translated: true
          settings.attribute :button2_url, type: :text
          settings.attribute :button2_text, type: :text, translated: true
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :background_section) do |content_block|
        content_block.cell = "helsinki/content_blocks/background_section"
        content_block.settings_form_cell = "helsinki/content_blocks/background_section_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.background_section.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button1_url, type: :text
          settings.attribute :button1_text, type: :text, translated: true
          settings.attribute :button2_url, type: :text
          settings.attribute :button2_text, type: :text, translated: true
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :image_section) do |content_block|
        content_block.cell = "helsinki/content_blocks/image_section"
        content_block.settings_form_cell = "helsinki/content_blocks/image_section_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.image_section.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :link_url, type: :text
          settings.attribute :link_text, type: :text, translated: true
        end

        content_block.images = [
          {
            name: :image,
            uploader: "Decidim::Helsinki::ImageSectionImageUploader"
          }
        ]

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :hero_with_card_left) do |content_block|
        content_block.cell = "helsinki/content_blocks/hero_with_card"
        content_block.settings_form_cell = "helsinki/content_blocks/hero_with_card_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.hero_with_card_left.name"

        content_block.images = [
          {
            name: :background_image,
            uploader: "Decidim::Helsinki::HeroImageUploader"
          }
        ]

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button1_url, type: :text
          settings.attribute :button1_text, type: :text, translated: true
          settings.attribute :button1_new_tab, type: :boolean, default: false
          settings.attribute :button2_url, type: :text
          settings.attribute :button2_text, type: :text, translated: true
          settings.attribute :button2_new_tab, type: :boolean, default: false
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :hero_with_card_right) do |content_block|
        content_block.cell = "helsinki/content_blocks/hero_with_card_right"
        content_block.settings_form_cell = "helsinki/content_blocks/hero_with_card_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.hero_with_card_right.name"

        content_block.images = [
          {
            name: :background_image,
            uploader: "Decidim::Helsinki::HeroImageUploader"
          }
        ]

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
          settings.attribute :description, type: :text, translated: true
          settings.attribute :button1_url, type: :text
          settings.attribute :button1_text, type: :text, translated: true
          settings.attribute :button1_new_tab, type: :boolean, default: false
          settings.attribute :button2_url, type: :text
          settings.attribute :button2_text, type: :text, translated: true
          settings.attribute :button2_new_tab, type: :boolean, default: false
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :highlighted_blogs) do |content_block|
        content_block.cell = "helsinki/content_blocks/highlighted_blogs"
        content_block.settings_form_cell = "helsinki/content_blocks/highlighted_blogs_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.highlighted_blogs.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
        end

        content_block.default!
      end

      Decidim.content_blocks.register(:homepage, :highlighted_results) do |content_block|
        content_block.cell = "helsinki/content_blocks/highlighted_results"
        content_block.settings_form_cell = "helsinki/content_blocks/highlighted_results_settings_form"
        content_block.public_name_key = "helsinki.content_blocks.highlighted_results.name"

        content_block.settings do |settings|
          settings.attribute :title, type: :text, translated: true
        end

        content_block.default!
      end
    end

    initializer "participatory_processes_admin_extensions" do
      Decidim::ParticipatoryProcesses::AdminEngine.routes.append do
        resource :participatory_processes_static_contents, only: [:show, :update]
      end
    end

    # Needed for the 0.25 active storage migration
    initializer "activestorage_migration" do
      next unless Decidim.const_defined?("CarrierWaveMigratorService")

      Decidim::CarrierWaveMigratorService.send(:remove_const, :MIGRATION_ATTRIBUTES).tap do |attributes|
        additional_attributes = [
          [Decidim::Blogs::Post, "card_image", Decidim::Cw::BlogPostImageUploader, "card_image"],
          [Decidim::Blogs::Post, "main_image", Decidim::Cw::BlogPostImageUploader, "main_image"],
          [Decidim::Category, "category_image", Decidim::Cw::CategoryImageUploader, "category_image"],
          [Decidim::Category, "category_icon", Decidim::Cw::CategoryIconUploader, "category_icon"]
        ]

        Decidim::CarrierWaveMigratorService.const_set(:MIGRATION_ATTRIBUTES, (attributes + additional_attributes).freeze)
      end
    end

    initializer "menu_extensions" do
      Decidim.menu :menu do |menu|
        # Add the results to the menu
        query = PublishedResourceFetcher.new(Decidim::Accountability::Result, current_organization).query

        menu.item(
          I18n.t("menu.results", scope: "decidim"),
          main_app.results_path,
          position: 2.1,
          if: query.any?,
          active: %r{^/results}
        )

        # Add the posts to the menu
        query = PublishedResourceFetcher.new(Decidim::Blogs::Post, current_organization).query

        menu.item(
          I18n.t("menu.posts", scope: "decidim"),
          main_app.posts_path,
          position: 2.2,
          if: query.any?,
          active: %r{^/posts}
        )

        # Add the informational pages (pages without a topic) to the menu
        menu.item(
          I18n.t("menu.info", scope: "decidim"),
          main_app.infos_path,
          position: 7.1,
          if: Decidim::StaticPage.where(topic: nil, organization: current_organization).any?,
          active: %r{^/info}
        )
      end
    end

    initializer "after_init" do
      config.after_initialize do
        # Cell customizations
        Cell::ViewModel.view_paths.prepend File.expand_path("#{Rails.application.root}/app/cells")
        Cell::ViewModel.view_paths.prepend File.expand_path("#{Rails.application.root}/app/views")
      end
    end

    initializer "customizations" do
      # See:
      # https://guides.rubyonrails.org/configuring.html#initialization-events
      #
      # Run before every request in development.
      config.to_prepare do
        # Helper extensions
        Decidim::Comments::CommentsHelper.include(CommentsHelperExtensions)
        Decidim::ScopesHelper.include(ScopesHelperExtensions)
        Decidim::ContextualHelpHelper.include(ContextualHelperExtensions)
        Decidim::Plans::PlanCellsHelper.include(PlanCellsHelperExtensions)

        # Command extensions
        Decidim::UpdateAccount.include(UpdateAccountOverrides)
        Decidim::Search.include(SearchOverrides)
        Decidim::CreateFollow.include(CreateFollowOverrides)
        Decidim::Blogs::Admin::CreatePost.include(CreateBlogPostOverrides)
        Decidim::Blogs::Admin::UpdatePost.include(UpdateBlogPostOverrides)

        # Controller extensions
        # Keep after helpers because these can load in helpers!
        Decidim::NeedsTosAccepted.include(NeedsTosAcceptedExtensions)
        Decidim::ApplicationController.include(ApplicationControllerExtensions)
        Decidim::Admin::HelpSectionsController.include(
          AdminHelpSectionsExtensions
        )
        Decidim::UserActivitiesController.include(ActivityResourceTypes)
        Decidim::UserTimelineController.include(ActivityResourceTypes)
        Decidim::ParticipatoryProcesses::ApplicationController.include(
          ParticipatoryProcessesApplicationExtensions
        )
        Decidim::ParticipatoryProcesses::ParticipatoryProcessesController.include(
          ParticipatoryProcessesExtensions
        )
        Decidim::SearchesController.include(SearchesControllerExtensions)
        Decidim::ProfilesController.include(ProfilesControllerExtensions)
        Decidim::UserActivitiesController.include(ProfilesControllerExtensions)
        Decidim::Blogs::Admin::PostsController.include(
          AdminBlogPostsControllerExtensions
        )
        Decidim::Plans::PlansController.include(PlansControllerExtensions)

        # Cell extensions
        Decidim::CardMCell.include(CardMCellOverrides)
        Decidim::AuthorCell.include(Decidim::SanitizeHelper)
        Decidim::CollapsibleListCell.include(CollapsibleListCellExtensions)
        Decidim::ContentBlocks::HeroCell.include(KoroHelper)
        Decidim::ParticipatoryProcesses::ProcessMCell.include(ProcessMCellExtensions)
        Decidim::Plans::PlanIndexCell.include(KoroHelper)
        Decidim::Plans::PlanViewCell.include(KoroHelper)
        Decidim::Plans::PlanFormCell.include(PlanFormCellExtensions)
        Decidim::Plans::PlanMCell.include(PlanMCellExtensions)
        Decidim::Meetings::JoinMeetingButtonCell.include(
          JoinMeetingButtonCellExtensions
        )
        Decidim::UserProfileCell.include(UserProfileCellExtensions)
        Decidim::Blogs::PostMCell.include(BlogPostMCellExtensions)
        Decidim::Accountability::ResultMCell.include(ResultMCellExtensions)
        Decidim::Accountability::TagsCell.include(AccountabilityTagsCellExtensions)
        Decidim::Comments::CommentCell.include(CommentCellExtensions)

        # Form extensions
        Decidim::Admin::CategoryForm.include(AdminCategoryFormExtensions)
        Decidim::AccountForm.include(AccountFormExtensions)
        Decidim::Blogs::Admin::PostForm.include(AdminBlogPostFormExtensions)

        # Permissions extensions
        Decidim::Plans::Permissions.include(PlansPermissionsExtensions)
        Decidim::MenuItemPresenter.include(MenuItemPresenterExtensions)

        # Model extensions
        Decidim::Category.include(CategoryExtensions)
        Decidim::User.include(UserExtensions)
        Decidim::Blogs::Post.include(BlogPostExtensions)
        Decidim::Accountability::Result.include(ResultExtensions)

        # View extensions
        ActionView::Base.include(Decidim::WidgetUrlsHelper)

        # Library extensions
        Decidim::FormBuilder.include(FormBuilderExtensions)

        # Fixes for (when replacing search for all occurences of the PR URL):
        # https://github.com/decidim/decidim/pull/7784
        Decidim::Meetings::Admin::DestroyMeeting.include(DestroyMeetingExtensions)
        Decidim::Meetings::Meeting.include(MeetingExtensions)
        Decidim::Meetings::MeetingPresenter.include(MeetingPresenterExtensions)
      end
    end
  end
end
