# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Run updates by following the Decidim upgrade instructions:
# https://github.com/decidim/decidim/blob/master/docs/getting_started.md#keeping-your-app-up-to-date
# DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/multibudget-maximum-votes" }.freeze
DECIDIM_VERSION = "0.25.2"

# Necessary for other gems
gem "decidim-core", DECIDIM_VERSION

# Core gems (unnecessary gems dropped)
gem "decidim-accountability", DECIDIM_VERSION
gem "decidim-admin", DECIDIM_VERSION
gem "decidim-api", DECIDIM_VERSION
gem "decidim-blogs", DECIDIM_VERSION
gem "decidim-comments", DECIDIM_VERSION
# gem "decidim-debates", DECIDIM_VERSION # depends on proposals
gem "decidim-forms", DECIDIM_VERSION
gem "decidim-meetings", DECIDIM_VERSION # depends on proposals
gem "decidim-pages", DECIDIM_VERSION
gem "decidim-participatory_processes", DECIDIM_VERSION
gem "decidim-surveys", DECIDIM_VERSION
gem "decidim-system", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-verifications", DECIDIM_VERSION

# Extra missing core dependencies.
# Should be fixed by: https://github.com/decidim/decidim/pull/7782
gem "searchlight", "~> 4.1"

# External modules
gem "decidim-accountability_simple", github: "mainio/decidim-module-accountability_simple", branch: "release/0.25-stable"
gem "decidim-antivirus", github: "mainio/decidim-module-antivirus", branch: "release/0.25-stable"
gem "decidim-apiauth", github: "mainio/decidim-module-apiauth", branch: "release/0.25-stable"
gem "decidim-favorites", github: "mainio/decidim-module-favorites", branch: "release/0.25-stable"
gem "decidim-feedback", github: "mainio/decidim-module-feedback", branch: "release/0.25-stable"
gem "decidim-locations", github: "mainio/decidim-module-locations", branch: "release/0.25-stable"
gem "decidim-plans", github: "mainio/decidim-module-plans", branch: "release/0.25-stable"
gem "decidim-redirects", github: "mainio/decidim-module-redirects", branch: "release/0.25-stable"
gem "decidim-tags", github: "mainio/decidim-module-tags", branch: "release/0.25-stable"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.25-stable"
gem "decidim-tunnistamo", github: "mainio/decidim-module-tunnistamo", branch: "release/0.25-stable"
gem "omniauth-tunnistamo", github: "mainio/omniauth-tunnistamo"

# For static maps, hasn't released an official release with the updated
# dependencies. GitHub version works fine.
gem "mapstatic", github: "crofty/mapstatic", branch: "master"

# The social-share-button assets are not added to the asset pipeline without
# having this gem required here. The gem is listed as a dependency for
# decidim-core but it is only required in decidim-proposals. Even if we locally
# require it in the application, the asset paths won't be added to the assets
# pipeline.
#
# This will be likely fixed by:
# https://github.com/decidim/decidim/pull/7690
gem "social-share-button", "~> 1.2", ">= 1.2.3"

# Managing locale datas
gem "ruby-cldr", "~> 0.3.0"

# HKI export
gem "rubyXL", "~> 3.4", ">= 3.4.17"

gem "puma", ">= 5.5.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "4.0.4"

  # Profiling gems
  gem "bullet"
  gem "flamegraph"
  gem "memory_profiler"
  gem "rack-mini-profiler", require: false
  gem "stackprof"
end

# Faker is also needed in staging env in order to generate dummy data.
group :development, :test, :staging do
  gem "faker", "~> 1.9"
end

group :production, :production_paahtimo, :staging, :staging_paahtimo do
  gem "dotenv-rails", "~> 2.1", ">= 2.1.1"

  # resque-scheduler still depends on resque ~> 1.25
  # Keep an eye on:
  # https://github.com/resque/resque-scheduler/pull/661
  gem "resque", "~> 1.26"
  gem "resque-scheduler", "~> 4.0"

  # For integrating with Azure files
  # There's no maintained ruby gem for direct integration which is why we wrap
  # the classes ourselves.
  # gem "azure-storage-blob"
end

group :test do
  gem "database_cleaner"
  gem "rspec-rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
