# frozen_string_literal: true

# Fix GraphQL type reloading:
# https://github.com/decidim/decidim/issues/4202
#
# This may be removed after that issue is fixed. See steps to replicate from
# the issue and test it out before removing this.
#
# There is a code reload issue happening because the GraphQL type
# definitions are reloaded every time the code is changed. To fix this,
# remove those classes from the autoload paths and manually redefine them
# after they have been undefined.
if Rails.env.development?
  # First look up all type definitions in the Decidim gems' `app/types` dirs.
  constants = {}
  paths = ActiveSupport::Dependencies.autoload_paths.reject do |path|
    next unless path =~ %r{/gems/decidim-(.*)-([0-9]+\.)+[0-9]/app/types}

    Dir["#{path}/**/*.rb"].each do |file|
      matches = file.match(%r{/decidim/(.*)/(.*)\.rb})
      next unless matches

      mod_name = "Decidim::#{matches[1].camelcase}"
      type_name = matches[2].camelcase
      constants[mod_name] ||= []
      constants[mod_name] << type_name
    end
  end

  # After initialization, fetch all types and save them locally. Modify the
  # autoload paths to prevent these being reloaded.
  redefine = {}
  Rails.application.config.after_initialize do
    constants.each do |mod_name, types|
      redefine[mod_name] = {}
      types.each do |type_name|
        redefine[mod_name][type_name] = Object.const_get("#{mod_name}::#{type_name}")
      end
    end

    ActiveSupport::Dependencies.autoload_paths = paths
  end

  # Finally, add `to_prepare` hook to redefine the constants if they have been
  # undeclared during code reload.
  Rails.application.config.to_prepare do
    redefine.each do |mod_name, types|
      types.each do |type_name, type|
        const = "#{mod_name}::#{type_name}"
        unless Object.const_defined?(const)
          mod = Object.const_get(mod_name)
          mod.const_set(type_name, type)
        end
      end
    end
  end
end
