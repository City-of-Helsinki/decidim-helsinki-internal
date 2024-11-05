# frozen_string_literal: true
# This migration comes from decidim_helsinki_profile (originally 20230604091238)

class AddPseudonimizedPinToAuthorizations < ActiveRecord::Migration[6.0]
  def up
    return if column_exists?(:decidim_authorizations, :pseudonymized_pin)

    add_column :decidim_authorizations, :pseudonymized_pin, :string
    add_index :decidim_authorizations, :pseudonymized_pin
  end

  def down
    return unless column_exists?(:decidim_authorizations, :pseudonymized_pin)

    remove_column :decidim_authorizations, :pseudonymized_pin
  end
end
