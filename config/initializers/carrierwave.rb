# frozen_string_literal: true

# Default CarrierWave setup.
#
CarrierWave.configure do |config|
  config.permissions = 0o666
  config.directory_permissions = 0o777
  config.storage = :file
  config.enable_processing = !Rails.env.test?
end

if Rails.application.secrets.azure_blob.present?
  # Azure blob storage setup (local repository implementation)
  require "carrierwave_azure_blob"

  azure = Rails.application.secrets.azure_blob
  CarrierWave.configure do |config|
    config.storage = :azure_blob
    config.azure_storage_account_name = azure[:storage_account_name]
    config.azure_storage_access_key = azure[:storage_access_key]
    config.azure_storage_blob_host = azure[:storage_blob_host] # optional
    config.azure_container = azure[:container]
    config.asset_host = azure[:host] # optional
  end
else
  CarrierWave.configure do |config|
    # Fix `.url` pointing to full URLs for the uploaders. Affects e.g. the og meta
    # tags for social images.
    config.asset_host = ActionController::Base.asset_host
  end
end

# Setup CarrierWave to use Amazon S3. Add `gem "fog-aws" to your Gemfile.
#
# CarrierWave.configure do |config|
#   config.storage = :fog
#   config.fog_provider = 'fog/aws'                                             # required
#   config.fog_credentials = {
#     provider:              'AWS',                                             # required
#     aws_access_key_id:     Rails.configuration.secrets.aws_access_key_id,     # required
#     aws_secret_access_key: Rails.configuration.secrets.aws_secret_access_key, # required
#     region:                'eu-west-1',                                       # optional, defaults to 'us-east-1'
#     host:                  's3.example.com',                                  # optional, defaults to nil
#     endpoint:              'https://s3.example.com:8080'                      # optional, defaults to nil
#   }
#   config.fog_directory  = 'name_of_directory'                                 # required
#   config.fog_public     = false                                               # optional, defaults to true
#   config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }    # optional, defaults to {}
# end
