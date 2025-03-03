# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.application_name = "Ideapaahtimo"

  # Wrapper class can be used to customize the coloring of the platform per
  # environment. This is used mainly for the Ideapaahtimo/KuVa instance.
  config.wrapper_class = "wrapper-paahtimo"

  config.meta_image = "media/images/social-ideapaahtimo-wide.jpg"

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # The feedback email in the footer of the site
  config.feedback_email = "ideapaahtimo@hel.fi"

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = "http://localhost:3000"

  # Add the same loggers as we have in normal development mode
  config.action_view.logger = Logger.new(STDOUT)
  config.active_record.logger = Logger.new(STDOUT)

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Default URL for mailer (Devise)
  config.action_mailer.default_url_options = {
    protocol: "http",
    host: "localhost",
    port: 3000
    # from: "info@local.dev" # Causes forms to break e.g. when publishing proposal
  }

  # Use letter_opener
  config.action_mailer.delivery_method = :letter_opener_web

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
