# frozen_string_literal: true
# This migration comes from decidim_accountability (originally 20220331150008)

class AddTitleToTimelineEntries < ActiveRecord::Migration[6.1]
  def change
    # Already added by accountability simple
    # add_column :decidim_accountability_timeline_entries, :title, :jsonb
  end
end
