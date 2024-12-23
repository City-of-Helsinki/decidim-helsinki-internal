# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_11_07_121154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "decidim_accountability_results", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.string "reference"
    t.date "start_date"
    t.date "end_date"
    t.decimal "progress", precision: 5, scale: 2
    t.integer "parent_id"
    t.integer "decidim_accountability_status_id"
    t.integer "decidim_component_id"
    t.integer "decidim_scope_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "children_count", default: 0
    t.float "weight", default: 1.0
    t.string "external_id"
    t.integer "comments_count", default: 0, null: false
    t.string "main_image"
    t.string "list_image"
    t.boolean "use_default_details", default: true
    t.jsonb "summary"
    t.integer "coauthorships_count", default: 0, null: false
    t.datetime "published_at"
    t.index ["coauthorships_count"], name: "idx_decidim_accountability_results_on_result_coauth_count"
    t.index ["decidim_accountability_status_id"], name: "decidim_accountability_results_on_status_id"
    t.index ["decidim_component_id"], name: "index_decidim_accountability_results_on_decidim_component_id"
    t.index ["decidim_scope_id"], name: "index_decidim_accountability_results_on_decidim_scope_id"
    t.index ["external_id"], name: "index_decidim_accountability_results_on_external_id"
    t.index ["parent_id"], name: "decidim_accountability_results_on_parent_id"
  end

  create_table "decidim_accountability_simple_result_detail_values", force: :cascade do |t|
    t.bigint "decidim_accountability_result_detail_id"
    t.bigint "decidim_accountability_result_id"
    t.jsonb "description"
    t.index ["decidim_accountability_result_detail_id"], name: "index_accountability_result_common_detail_values_on_detail_id"
    t.index ["decidim_accountability_result_id"], name: "index_accountability_result_cmn_detail_values_on_results_id"
  end

  create_table "decidim_accountability_simple_result_details", force: :cascade do |t|
    t.bigint "accountability_result_detailable_id"
    t.integer "position"
    t.string "icon"
    t.jsonb "title"
    t.string "accountability_result_detailable_type"
    t.index ["accountability_result_detailable_id", "accountability_result_detailable_type"], name: "index_decidim_accountability_simple_result_dets_on_detailable"
  end

  create_table "decidim_accountability_simple_result_links", force: :cascade do |t|
    t.bigint "decidim_accountability_result_id"
    t.integer "position"
    t.jsonb "label"
    t.jsonb "url"
    t.index ["decidim_accountability_result_id"], name: "index_decidim_accountability_result_links_on_results_id"
  end

  create_table "decidim_accountability_statuses", id: :serial, force: :cascade do |t|
    t.string "key"
    t.jsonb "name"
    t.integer "decidim_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description"
    t.integer "progress"
    t.string "color"
    t.index ["decidim_component_id"], name: "index_decidim_accountability_statuses_on_decidim_component_id"
  end

  create_table "decidim_accountability_timeline_entries", id: :serial, force: :cascade do |t|
    t.date "entry_date"
    t.jsonb "description"
    t.integer "decidim_accountability_result_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "title"
    t.date "end_date"
    t.index ["decidim_accountability_result_id"], name: "index_decidim_accountability_timeline_entries_on_results_id"
    t.index ["entry_date"], name: "index_decidim_accountability_timeline_entries_on_entry_date"
  end

  create_table "decidim_action_logs", force: :cascade do |t|
    t.bigint "decidim_organization_id", null: false
    t.bigint "decidim_user_id", null: false
    t.bigint "decidim_component_id"
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "participatory_space_type"
    t.bigint "participatory_space_id"
    t.string "action", null: false
    t.jsonb "extra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "version_id"
    t.string "visibility", default: "admin-only"
    t.integer "decidim_scope_id"
    t.integer "decidim_area_id"
    t.index ["created_at"], name: "index_decidim_action_logs_on_created_at"
    t.index ["decidim_area_id"], name: "index_decidim_action_logs_on_decidim_area_id"
    t.index ["decidim_component_id"], name: "index_action_logs_on_component_id"
    t.index ["decidim_organization_id"], name: "index_action_logs_on_organization_id"
    t.index ["decidim_scope_id"], name: "index_decidim_action_logs_on_decidim_scope_id"
    t.index ["decidim_user_id"], name: "index_action_logs_on_user_id"
    t.index ["participatory_space_type", "participatory_space_id"], name: "index_action_logs_on_space_type_and_id"
    t.index ["resource_type", "resource_id"], name: "index_action_logs_on_resource_type_and_id"
    t.index ["version_id"], name: "index_decidim_action_logs_on_version_id"
    t.index ["visibility"], name: "index_decidim_action_logs_on_visibility"
  end

  create_table "decidim_amendments", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.string "decidim_amendable_type"
    t.bigint "decidim_amendable_id"
    t.string "decidim_emendation_type"
    t.bigint "decidim_emendation_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_amendable_id", "decidim_amendable_type"], name: "index_on_amendable"
    t.index ["decidim_emendation_id"], name: "index_decidim_amendments_on_decidim_emendation_id"
    t.index ["decidim_user_id", "decidim_amendable_id", "decidim_amendable_type"], name: "index_on_amender_and_amendable"
    t.index ["decidim_user_id"], name: "index_decidim_amendments_on_decidim_user_id"
    t.index ["state"], name: "index_decidim_amendments_on_state"
  end

  create_table "decidim_apiauth_jwt_blacklists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_decidim_apiauth_jwt_blacklists_on_jti"
  end

  create_table "decidim_area_types", force: :cascade do |t|
    t.bigint "decidim_organization_id"
    t.jsonb "name", null: false
    t.jsonb "plural", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_area_types_on_decidim_organization_id"
  end

  create_table "decidim_areas", force: :cascade do |t|
    t.jsonb "name"
    t.bigint "area_type_id"
    t.bigint "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_type_id"], name: "index_decidim_areas_on_area_type_id"
    t.index ["decidim_organization_id"], name: "index_decidim_areas_on_decidim_organization_id"
  end

  create_table "decidim_attachment_collections", force: :cascade do |t|
    t.jsonb "name", null: false
    t.jsonb "description", null: false
    t.integer "weight", default: 0, null: false
    t.string "collection_for_type", null: false
    t.bigint "collection_for_id", null: false
    t.index ["collection_for_type", "collection_for_id"], name: "decidim_attachment_collections_collection_for_id_and_type"
  end

  create_table "decidim_attachments", id: :serial, force: :cascade do |t|
    t.jsonb "title", null: false
    t.jsonb "description"
    t.string "file"
    t.string "content_type", null: false
    t.string "file_size", null: false
    t.integer "attached_to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attached_to_type", null: false
    t.integer "weight", default: 0, null: false
    t.integer "attachment_collection_id"
    t.index ["attached_to_id", "attached_to_type"], name: "index_decidim_attachments_on_attached_to"
    t.index ["attachment_collection_id"], name: "index_decidim_attachments_on_attachment_collection_id"
  end

  create_table "decidim_authorizations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "metadata"
    t.integer "decidim_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unique_id"
    t.datetime "granted_at"
    t.jsonb "verification_metadata", default: {}
    t.string "verification_attachment"
    t.string "pseudonymized_pin"
    t.index ["decidim_user_id", "name"], name: "index_decidim_authorizations_on_decidim_user_id_and_name", unique: true
    t.index ["decidim_user_id"], name: "index_decidim_authorizations_on_decidim_user_id"
    t.index ["pseudonymized_pin"], name: "index_decidim_authorizations_on_pseudonymized_pin"
    t.index ["unique_id"], name: "index_decidim_authorizations_on_unique_id"
  end

  create_table "decidim_blogs_posts", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "body"
    t.integer "decidim_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "decidim_author_id", null: false
    t.string "decidim_author_type", null: false
    t.integer "decidim_user_group_id"
    t.integer "endorsements_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.string "card_image"
    t.string "main_image"
    t.integer "follows_count", default: 0, null: false
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_blogs_posts_on_decidim_author"
    t.index ["decidim_component_id"], name: "index_decidim_blogs_posts_on_decidim_component_id"
    t.index ["decidim_user_group_id"], name: "index_decidim_blogs_posts_on_decidim_user_group_id"
  end

  create_table "decidim_categories", id: :serial, force: :cascade do |t|
    t.jsonb "name", null: false
    t.jsonb "description"
    t.integer "parent_id"
    t.integer "decidim_participatory_space_id"
    t.string "decidim_participatory_space_type"
    t.string "color"
    t.integer "weight", default: 0, null: false
    t.string "category_image"
    t.string "category_icon"
    t.index ["decidim_participatory_space_id", "decidim_participatory_space_type"], name: "index_decidim_categories_on_decidim_participatory_space"
    t.index ["parent_id"], name: "index_decidim_categories_on_parent_id"
  end

  create_table "decidim_categorizations", force: :cascade do |t|
    t.bigint "decidim_category_id", null: false
    t.string "categorizable_type", null: false
    t.bigint "categorizable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categorizable_type", "categorizable_id"], name: "decidim_categorizations_categorizable_id_and_type"
    t.index ["decidim_category_id"], name: "index_decidim_categorizations_on_decidim_category_id"
  end

  create_table "decidim_coauthorships", force: :cascade do |t|
    t.bigint "decidim_author_id", null: false
    t.bigint "decidim_user_group_id"
    t.string "coauthorable_type"
    t.bigint "coauthorable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decidim_author_type", null: false
    t.index ["coauthorable_type", "coauthorable_id"], name: "index_coauthorable_on_coauthorship"
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_coauthorships_on_decidim_author"
    t.index ["decidim_user_group_id"], name: "index_user_group_on_coauthorsihp"
  end

  create_table "decidim_comments_comment_votes", id: :serial, force: :cascade do |t|
    t.integer "weight", null: false
    t.integer "decidim_comment_id", null: false
    t.integer "decidim_author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decidim_author_type", null: false
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_comments_comment_votes_on_decidim_author"
    t.index ["decidim_author_id"], name: "decidim_comments_comment_vote_author"
    t.index ["decidim_comment_id", "decidim_author_id"], name: "decidim_comments_comment_vote_comment_author_unique", unique: true
    t.index ["decidim_comment_id"], name: "decidim_comments_comment_vote_comment"
  end

  create_table "decidim_comments_comments", id: :serial, force: :cascade do |t|
    t.string "decidim_commentable_type", null: false
    t.integer "decidim_commentable_id", null: false
    t.integer "decidim_author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "depth", default: 0, null: false
    t.integer "alignment", default: 0, null: false
    t.integer "decidim_user_group_id"
    t.string "decidim_root_commentable_type", null: false
    t.integer "decidim_root_commentable_id", null: false
    t.string "decidim_author_type", null: false
    t.jsonb "body"
    t.integer "comments_count", default: 0, null: false
    t.string "decidim_participatory_space_type"
    t.integer "decidim_participatory_space_id"
    t.datetime "deleted_at"
    t.integer "up_votes_count", default: 0, null: false
    t.integer "down_votes_count", default: 0, null: false
    t.index ["created_at"], name: "index_decidim_comments_comments_on_created_at"
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_comments_comments_on_decidim_author"
    t.index ["decidim_author_id"], name: "decidim_comments_comment_author"
    t.index ["decidim_commentable_type", "decidim_commentable_id"], name: "decidim_comments_comment_commentable"
    t.index ["decidim_participatory_space_id", "decidim_participatory_space_type"], name: "index_decidim_comments_on_decidim_participatory_space"
    t.index ["decidim_root_commentable_type", "decidim_root_commentable_id"], name: "decidim_comments_comment_root_commentable"
    t.index ["decidim_user_group_id"], name: "index_decidim_comments_comments_on_decidim_user_group_id"
  end

  create_table "decidim_components", id: :serial, force: :cascade do |t|
    t.string "manifest_name"
    t.jsonb "name"
    t.integer "participatory_space_id", null: false
    t.jsonb "settings", default: {}
    t.integer "weight", default: 0
    t.jsonb "permissions"
    t.datetime "published_at"
    t.string "participatory_space_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participatory_space_id", "participatory_space_type"], name: "index_decidim_components_on_decidim_participatory_space"
  end

  create_table "decidim_content_block_attachments", force: :cascade do |t|
    t.string "name"
    t.bigint "decidim_content_block_id", null: false
    t.index ["decidim_content_block_id"], name: "decidim_content_block_attachments_on_content_block"
  end

  create_table "decidim_content_blocks", force: :cascade do |t|
    t.integer "decidim_organization_id", null: false
    t.string "manifest_name", null: false
    t.string "scope_name", null: false
    t.jsonb "settings"
    t.datetime "published_at"
    t.integer "weight"
    t.jsonb "images", default: {}
    t.integer "scoped_resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_organization_id", "scope_name", "scoped_resource_id", "manifest_name"], name: "idx_decidim_content_blocks_org_id_scope_scope_id_manifest"
    t.index ["decidim_organization_id"], name: "index_decidim_content_blocks_on_decidim_organization_id"
    t.index ["manifest_name"], name: "index_decidim_content_blocks_on_manifest_name"
    t.index ["published_at"], name: "index_decidim_content_blocks_on_published_at"
    t.index ["scope_name"], name: "index_decidim_content_blocks_on_scope_name"
  end

  create_table "decidim_contextual_help_sections", force: :cascade do |t|
    t.string "section_id", null: false
    t.bigint "organization_id", null: false
    t.jsonb "content", null: false
    t.index ["organization_id"], name: "index_decidim_contextual_help_sections_on_organization_id"
    t.index ["section_id"], name: "index_decidim_contextual_help_sections_on_section_id"
  end

  create_table "decidim_debates_debates", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.jsonb "instructions"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "image"
    t.integer "decidim_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "information_updates"
    t.integer "decidim_author_id", null: false
    t.string "reference"
    t.integer "decidim_user_group_id"
    t.string "decidim_author_type", null: false
    t.datetime "closed_at"
    t.jsonb "conclusions"
    t.integer "endorsements_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "last_comment_at"
    t.integer "last_comment_by_id"
    t.string "last_comment_by_type"
    t.index ["closed_at"], name: "index_decidim_debates_debates_on_closed_at"
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_debates_debates_on_decidim_author"
    t.index ["decidim_component_id"], name: "index_decidim_debates_debates_on_decidim_component_id"
    t.index ["decidim_user_group_id"], name: "index_decidim_debates_debates_on_decidim_user_group_id"
    t.index ["endorsements_count"], name: "idx_decidim_debates_debates_on_endorsemnts_count"
  end

  create_table "decidim_editor_images", force: :cascade do |t|
    t.bigint "decidim_author_id", null: false
    t.bigint "decidim_organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_author_id"], name: "decidim_editor_images_author"
    t.index ["decidim_organization_id"], name: "decidim_editor_images_constraint_organization"
  end

  create_table "decidim_endorsements", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "decidim_author_type"
    t.bigint "decidim_author_id"
    t.integer "decidim_user_group_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_author_type", "decidim_author_id"], name: "idx_endorsements_authors"
    t.index ["decidim_user_group_id"], name: "index_decidim_endorsements_on_decidim_user_group_id"
    t.index ["resource_type", "resource_id", "decidim_author_type", "decidim_author_id", "decidim_user_group_id"], name: "idx_endorsements_rsrcs_and_authors", unique: true
    t.index ["resource_type", "resource_id"], name: "index_decidim_endorsements_on_resource_type_and_resource_id"
  end

  create_table "decidim_favorites_favorites", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.string "decidim_favoritable_type"
    t.bigint "decidim_favoritable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_favoritable_id", "decidim_favoritable_type"], name: "index_on_favoritable"
    t.index ["decidim_user_id", "decidim_favoritable_id", "decidim_favoritable_type"], name: "index_uniq_on_favorites_user_and_favoritable", unique: true
    t.index ["decidim_user_id"], name: "index_decidim_favorites_favorites_on_decidim_user_id"
  end

  create_table "decidim_feedback_feedbacks", force: :cascade do |t|
    t.integer "decidim_organization_id"
    t.integer "rating"
    t.text "body", null: false
    t.boolean "contact_request", default: false
    t.jsonb "metadata"
    t.bigint "decidim_user_id", null: false
    t.string "decidim_feedbackable_type"
    t.bigint "decidim_feedbackable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_feedbackable_id", "decidim_feedbackable_type"], name: "index_on_feedbackable"
    t.index ["decidim_organization_id"], name: "index_decidim_feedback_feedbacks_on_decidim_organization_id"
    t.index ["decidim_user_id", "decidim_feedbackable_id", "decidim_feedbackable_type"], name: "index_uniq_on_feedbacks_user_and_feedbackable"
    t.index ["decidim_user_id"], name: "index_decidim_feedback_feedbacks_on_decidim_user_id"
  end

  create_table "decidim_feedback_recipient_groups", force: :cascade do |t|
    t.integer "decidim_organization_id"
    t.jsonb "name"
    t.text "recipient_emails", default: [], array: true
    t.jsonb "metadata_conditions", default: {}
    t.index ["decidim_organization_id"], name: "index_decidim_feedback_recipient_groups_on_organization_id"
  end

  create_table "decidim_follows", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.string "decidim_followable_type"
    t.bigint "decidim_followable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_followable_id", "decidim_followable_type"], name: "index_follows_followable_id_and_type"
    t.index ["decidim_user_id", "decidim_followable_id", "decidim_followable_type"], name: "index_uniq_on_follows_user_and_followable", unique: true
    t.index ["decidim_user_id"], name: "index_decidim_follows_on_decidim_user_id"
  end

  create_table "decidim_forms_answer_choices", force: :cascade do |t|
    t.bigint "decidim_answer_id"
    t.bigint "decidim_answer_option_id"
    t.integer "position"
    t.jsonb "body"
    t.text "custom_body"
    t.integer "decidim_question_matrix_row_id"
    t.index ["decidim_answer_id"], name: "index_decidim_forms_answer_choices_answer_id"
    t.index ["decidim_answer_option_id"], name: "index_decidim_forms_answer_choices_answer_option_id"
  end

  create_table "decidim_forms_answer_options", force: :cascade do |t|
    t.bigint "decidim_question_id"
    t.jsonb "body"
    t.boolean "free_text"
    t.index ["decidim_question_id"], name: "index_decidim_forms_answer_options_question_id"
  end

  create_table "decidim_forms_answers", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "decidim_user_id"
    t.integer "decidim_questionnaire_id"
    t.integer "decidim_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_token", default: "", null: false
    t.string "ip_hash"
    t.index ["decidim_question_id"], name: "index_decidim_forms_answers_question_id"
    t.index ["decidim_questionnaire_id"], name: "index_decidim_forms_answers_on_decidim_questionnaire_id"
    t.index ["decidim_user_id"], name: "index_decidim_forms_answers_on_decidim_user_id"
    t.index ["ip_hash"], name: "index_decidim_forms_answers_on_ip_hash"
    t.index ["session_token"], name: "index_decidim_forms_answers_on_session_token"
  end

  create_table "decidim_forms_display_conditions", force: :cascade do |t|
    t.bigint "decidim_question_id", null: false
    t.bigint "decidim_condition_question_id", null: false
    t.bigint "decidim_answer_option_id"
    t.integer "condition_type", default: 0, null: false
    t.jsonb "condition_value"
    t.boolean "mandatory", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_answer_option_id"], name: "decidim_forms_display_condition_answer_option"
    t.index ["decidim_condition_question_id"], name: "decidim_forms_display_condition_condition_question"
    t.index ["decidim_question_id"], name: "decidim_forms_display_condition_question"
  end

  create_table "decidim_forms_question_matrix_rows", force: :cascade do |t|
    t.bigint "decidim_question_id"
    t.integer "position"
    t.jsonb "body"
    t.index ["decidim_question_id"], name: "index_decidim_forms_question_matrix_questionnaire_id"
    t.index ["position"], name: "index_decidim_forms_question_matrix_rows_on_position"
  end

  create_table "decidim_forms_questionnaires", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.jsonb "tos"
    t.string "questionnaire_for_type"
    t.integer "questionnaire_for_id"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "salt"
    t.index ["questionnaire_for_type", "questionnaire_for_id"], name: "index_decidim_forms_questionnaires_questionnaire_for"
  end

  create_table "decidim_forms_questions", id: :serial, force: :cascade do |t|
    t.integer "decidim_questionnaire_id"
    t.integer "position"
    t.string "question_type"
    t.boolean "mandatory"
    t.jsonb "body"
    t.jsonb "description"
    t.integer "max_choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_characters", default: 0
    t.index ["decidim_questionnaire_id"], name: "index_decidim_forms_questions_on_decidim_questionnaire_id"
    t.index ["position"], name: "index_decidim_forms_questions_on_position"
  end

  create_table "decidim_gamification_badge_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "badge_name", null: false
    t.integer "value", default: 0, null: false
    t.index ["user_id"], name: "index_decidim_gamification_badge_scores_on_user_id"
  end

  create_table "decidim_hashtags", force: :cascade do |t|
    t.bigint "decidim_organization_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_hashtags_on_decidim_organization_id"
    t.index ["name"], name: "index_decidim_hashtags_on_name"
  end

  create_table "decidim_helsinki_profile_session_infos", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.text "id_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_user_id"], name: "index_decidim_helsinki_profile_session_infos_on_decidim_user_id"
  end

  create_table "decidim_identities", id: :serial, force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", null: false
    t.integer "decidim_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "decidim_organization_id"
    t.index ["decidim_organization_id"], name: "index_decidim_identities_on_decidim_organization_id"
    t.index ["decidim_user_id"], name: "index_decidim_identities_on_decidim_user_id"
    t.index ["provider", "uid", "decidim_organization_id"], name: "decidim_identities_provider_uid_organization_unique", unique: true
  end

  create_table "decidim_impersonation_logs", force: :cascade do |t|
    t.bigint "decidim_admin_id"
    t.bigint "decidim_user_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reason"
    t.index ["decidim_admin_id"], name: "index_decidim_impersonation_logs_on_decidim_admin_id"
    t.index ["decidim_user_id"], name: "index_decidim_impersonation_logs_on_decidim_user_id"
  end

  create_table "decidim_locations_locations", force: :cascade do |t|
    t.text "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decidim_locations_locatable_type", null: false
    t.bigint "decidim_locations_locatable_id", null: false
    t.string "shape"
    t.jsonb "geojson"
    t.index ["decidim_locations_locatable_type", "decidim_locations_locatable_id"], name: "index_on_decidim_locations_locatable"
  end

  create_table "decidim_meetings_agenda_items", force: :cascade do |t|
    t.bigint "decidim_agenda_id"
    t.integer "position"
    t.bigint "parent_id"
    t.integer "duration"
    t.jsonb "title"
    t.jsonb "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_agenda_id"], name: "index_decidim_meetings_agenda_items_on_decidim_agenda_id"
    t.index ["parent_id"], name: "index_decidim_meetings_agenda_items_on_parent_id"
  end

  create_table "decidim_meetings_agendas", force: :cascade do |t|
    t.jsonb "title"
    t.bigint "decidim_meeting_id", null: false
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_meeting_id"], name: "index_decidim_meetings_agendas_on_decidim_meeting_id"
  end

  create_table "decidim_meetings_answer_choices", force: :cascade do |t|
    t.bigint "decidim_answer_id"
    t.bigint "decidim_answer_option_id"
    t.integer "position"
    t.jsonb "body"
    t.text "custom_body"
    t.index ["decidim_answer_id"], name: "index_decidim_meetings_answer_choices_answer_id"
    t.index ["decidim_answer_option_id"], name: "index_decidim_meetings_answer_choices_answer_option_id"
  end

  create_table "decidim_meetings_answer_options", force: :cascade do |t|
    t.bigint "decidim_question_id"
    t.jsonb "body"
    t.index ["decidim_question_id"], name: "index_decidim_meetings_answer_options_question_id"
  end

  create_table "decidim_meetings_answers", force: :cascade do |t|
    t.bigint "decidim_user_id"
    t.bigint "decidim_questionnaire_id"
    t.bigint "decidim_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_question_id"], name: "index_decidim_meetings_answers_question_id"
    t.index ["decidim_questionnaire_id"], name: "index_decidim_meetings_answers_on_decidim_questionnaire_id"
    t.index ["decidim_user_id"], name: "index_decidim_meetings_answers_on_decidim_user_id"
  end

  create_table "decidim_meetings_invites", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.bigint "decidim_meeting_id", null: false
    t.datetime "sent_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_meeting_id"], name: "index_decidim_meetings_invites_on_decidim_meeting_id"
    t.index ["decidim_user_id"], name: "index_decidim_meetings_invites_on_decidim_user_id"
  end

  create_table "decidim_meetings_meetings", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "address"
    t.jsonb "location"
    t.jsonb "location_hints"
    t.integer "decidim_component_id"
    t.integer "decidim_author_id"
    t.integer "decidim_scope_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "closing_report"
    t.integer "attendees_count"
    t.integer "contributions_count"
    t.text "attending_organizations"
    t.time "closed_at"
    t.float "latitude"
    t.float "longitude"
    t.string "reference"
    t.boolean "registrations_enabled", default: false, null: false
    t.integer "available_slots", default: 0, null: false
    t.jsonb "registration_terms"
    t.integer "reserved_slots", default: 0, null: false
    t.boolean "private_meeting", default: false
    t.boolean "transparent", default: true
    t.boolean "registration_form_enabled", default: false
    t.string "decidim_author_type"
    t.integer "decidim_user_group_id"
    t.integer "comments_count", default: 0, null: false
    t.string "salt"
    t.string "online_meeting_url"
    t.string "type_of_meeting", default: "in_person"
    t.string "registration_type", default: "registration_disabled", null: false
    t.string "registration_url"
    t.integer "follows_count", default: 0, null: false
    t.boolean "customize_registration_email", default: false
    t.jsonb "registration_email_custom_content"
    t.datetime "published_at"
    t.string "video_url"
    t.string "audio_url"
    t.boolean "closing_visible"
    t.boolean "comments_enabled", default: true
    t.datetime "comments_start_time"
    t.datetime "comments_end_time"
    t.string "state"
    t.integer "iframe_access_level", default: 0
    t.integer "iframe_embed_type", default: 0
    t.index ["decidim_author_id", "decidim_author_type"], name: "index_decidim_meetings_meetings_on_author"
    t.index ["decidim_author_id"], name: "index_decidim_meetings_meetings_on_decidim_author_id"
    t.index ["decidim_component_id"], name: "index_decidim_meetings_meetings_on_decidim_component_id"
    t.index ["decidim_scope_id"], name: "index_decidim_meetings_meetings_on_decidim_scope_id"
  end

  create_table "decidim_meetings_polls", force: :cascade do |t|
    t.bigint "decidim_meeting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_meeting_id"], name: "index_decidim_meetings_polls_on_decidim_meeting_id"
  end

  create_table "decidim_meetings_questionnaires", force: :cascade do |t|
    t.string "questionnaire_for_type"
    t.bigint "questionnaire_for_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["questionnaire_for_type", "questionnaire_for_id"], name: "index_decidim_meetings_questionnaires_questionnaire_for"
  end

  create_table "decidim_meetings_questions", force: :cascade do |t|
    t.bigint "decidim_questionnaire_id"
    t.integer "position"
    t.string "question_type"
    t.jsonb "body"
    t.integer "max_choices"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["decidim_questionnaire_id"], name: "index_decidim_meetings_questions_on_decidim_questionnaire_id"
    t.index ["position"], name: "index_decidim_meetings_questions_on_position"
  end

  create_table "decidim_meetings_registrations", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.bigint "decidim_meeting_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.datetime "validated_at"
    t.bigint "decidim_user_group_id"
    t.boolean "public_participation", default: false
    t.index ["decidim_meeting_id"], name: "index_decidim_meetings_registrations_on_decidim_meeting_id"
    t.index ["decidim_user_group_id"], name: "index_decidim_meetings_registrations_on_decidim_user_group_id"
    t.index ["decidim_user_id", "decidim_meeting_id"], name: "decidim_meetings_registrations_user_meeting_unique", unique: true
    t.index ["decidim_user_id"], name: "index_decidim_meetings_registrations_on_decidim_user_id"
  end

  create_table "decidim_meetings_services", force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.bigint "decidim_meeting_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_meeting_id"], name: "index_decidim_meetings_services_on_decidim_meeting_id"
  end

  create_table "decidim_messaging_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decidim_messaging_messages", force: :cascade do |t|
    t.bigint "decidim_conversation_id", null: false
    t.bigint "decidim_sender_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_conversation_id"], name: "index_decidim_messaging_messages_on_decidim_conversation_id"
    t.index ["decidim_sender_id"], name: "index_decidim_messaging_messages_on_decidim_sender_id"
  end

  create_table "decidim_messaging_participations", force: :cascade do |t|
    t.bigint "decidim_conversation_id", null: false
    t.bigint "decidim_participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_conversation_id"], name: "index_conversation_participations_on_conversation_id"
    t.index ["decidim_participant_id"], name: "index_conversation_participations_on_participant_id"
  end

  create_table "decidim_messaging_receipts", force: :cascade do |t|
    t.bigint "decidim_message_id", null: false
    t.bigint "decidim_recipient_id", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_message_id"], name: "index_decidim_messaging_receipts_on_decidim_message_id"
    t.index ["decidim_recipient_id"], name: "index_decidim_messaging_receipts_on_decidim_recipient_id"
  end

  create_table "decidim_metrics", force: :cascade do |t|
    t.date "day", null: false
    t.string "metric_type", null: false
    t.integer "cumulative", null: false
    t.integer "quantity", null: false
    t.bigint "decidim_organization_id", null: false
    t.string "participatory_space_type"
    t.bigint "participatory_space_id"
    t.string "related_object_type"
    t.bigint "related_object_id"
    t.bigint "decidim_category_id"
    t.index ["day", "metric_type", "decidim_organization_id", "participatory_space_type", "participatory_space_id", "related_object_type", "related_object_id", "decidim_category_id"], name: "idx_metric_by_day_type_org_space_object_category", unique: true
    t.index ["day"], name: "index_decidim_metrics_on_day"
    t.index ["decidim_category_id"], name: "index_decidim_metrics_on_decidim_category_id"
    t.index ["decidim_organization_id"], name: "index_decidim_metrics_on_decidim_organization_id"
    t.index ["metric_type"], name: "index_decidim_metrics_on_metric_type"
    t.index ["participatory_space_type", "participatory_space_id"], name: "index_metric_on_participatory_space_id_and_type"
    t.index ["related_object_type", "related_object_id"], name: "index_metric_on_related_object_id_and_type"
  end

  create_table "decidim_moderations", id: :serial, force: :cascade do |t|
    t.integer "decidim_participatory_space_id", null: false
    t.string "decidim_reportable_type", null: false
    t.integer "decidim_reportable_id", null: false
    t.integer "report_count", default: 0, null: false
    t.datetime "hidden_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "decidim_participatory_space_type", null: false
    t.text "reported_content"
    t.index ["decidim_participatory_space_id", "decidim_participatory_space_type"], name: "decidim_moderations_participatory_space"
    t.index ["decidim_reportable_type", "decidim_reportable_id"], name: "decidim_moderations_reportable", unique: true
    t.index ["hidden_at"], name: "decidim_moderations_hidden_at"
    t.index ["report_count"], name: "decidim_moderations_report_count"
  end

  create_table "decidim_newsletters", id: :serial, force: :cascade do |t|
    t.jsonb "subject"
    t.integer "organization_id"
    t.integer "author_id"
    t.integer "total_recipients"
    t.integer "total_deliveries"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "extended_data", default: {}
    t.index ["author_id"], name: "index_decidim_newsletters_on_author_id"
    t.index ["organization_id"], name: "index_decidim_newsletters_on_organization_id"
  end

  create_table "decidim_notifications", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.string "decidim_resource_type", null: false
    t.bigint "decidim_resource_id", null: false
    t.string "event_name", null: false
    t.string "event_class", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "extra"
    t.index ["decidim_resource_id"], name: "index_decidim_notifications_on_decidim_resource_id"
    t.index ["decidim_user_id"], name: "index_decidim_notifications_on_decidim_user_id"
  end

  create_table "decidim_organizations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "host", null: false
    t.string "default_locale", null: false
    t.string "available_locales", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description"
    t.string "logo"
    t.string "twitter_handler"
    t.string "favicon"
    t.string "instagram_handler"
    t.string "facebook_handler"
    t.string "youtube_handler"
    t.string "github_handler"
    t.string "official_img_header"
    t.string "official_img_footer"
    t.string "official_url"
    t.string "reference_prefix", null: false
    t.string "secondary_hosts", default: [], array: true
    t.string "available_authorizations", default: [], array: true
    t.text "header_snippets"
    t.jsonb "cta_button_text"
    t.string "cta_button_path"
    t.boolean "enable_omnipresent_banner", default: false, null: false
    t.jsonb "omnipresent_banner_title"
    t.jsonb "omnipresent_banner_short_description"
    t.string "omnipresent_banner_url"
    t.boolean "highlighted_content_banner_enabled", default: false, null: false
    t.jsonb "highlighted_content_banner_title"
    t.jsonb "highlighted_content_banner_short_description"
    t.jsonb "highlighted_content_banner_action_title"
    t.jsonb "highlighted_content_banner_action_subtitle"
    t.string "highlighted_content_banner_action_url"
    t.string "highlighted_content_banner_image"
    t.datetime "tos_version"
    t.boolean "badges_enabled", default: false, null: false
    t.boolean "send_welcome_notification", default: false, null: false
    t.jsonb "welcome_notification_subject"
    t.jsonb "welcome_notification_body"
    t.integer "users_registration_mode", default: 0, null: false
    t.string "id_documents_methods", default: ["online"], array: true
    t.jsonb "id_documents_explanation_text", default: {}
    t.boolean "user_groups_enabled", default: false, null: false
    t.jsonb "colors", default: {}
    t.jsonb "smtp_settings"
    t.boolean "force_users_to_authenticate_before_access_organization", default: false
    t.jsonb "omniauth_settings"
    t.boolean "rich_text_editor_in_public_views", default: false
    t.jsonb "admin_terms_of_use_body"
    t.string "time_zone", limit: 255, default: "UTC"
    t.boolean "enable_machine_translations", default: false
    t.integer "comments_max_length", default: 1000
    t.jsonb "file_upload_settings"
    t.string "machine_translation_display_priority", default: "original", null: false
    t.string "external_domain_whitelist", default: [], array: true
    t.boolean "enable_participatory_space_filters", default: true
    t.index ["host"], name: "index_decidim_organizations_on_host", unique: true
    t.index ["name"], name: "index_decidim_organizations_on_name", unique: true
  end

  create_table "decidim_pages_pages", id: :serial, force: :cascade do |t|
    t.jsonb "body"
    t.integer "decidim_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_component_id"], name: "index_decidim_pages_pages_on_decidim_component_id"
  end

  create_table "decidim_participatory_process_groups", id: :serial, force: :cascade do |t|
    t.jsonb "title", null: false
    t.jsonb "description", null: false
    t.string "hero_image"
    t.integer "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hashtag"
    t.string "group_url"
    t.jsonb "developer_group"
    t.jsonb "local_area"
    t.jsonb "meta_scope"
    t.jsonb "target"
    t.jsonb "participatory_scope"
    t.jsonb "participatory_structure"
    t.boolean "promoted", default: false
    t.index ["decidim_organization_id"], name: "decidim_participatory_process_group_organization"
  end

  create_table "decidim_participatory_process_steps", id: :serial, force: :cascade do |t|
    t.jsonb "title", null: false
    t.jsonb "description"
    t.date "start_date"
    t.date "end_date"
    t.integer "decidim_participatory_process_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.integer "position"
    t.jsonb "cta_text", default: {}
    t.string "cta_path"
    t.index ["decidim_participatory_process_id", "active"], name: "unique_index_to_avoid_duplicate_active_steps", unique: true, where: "(active = true)"
    t.index ["decidim_participatory_process_id", "position"], name: "index_unique_position_for_process", unique: true
    t.index ["decidim_participatory_process_id"], name: "index_decidim_processes_steps__on_decidim_process_id"
    t.index ["position"], name: "index_order_by_position_for_steps"
  end

  create_table "decidim_participatory_process_types", force: :cascade do |t|
    t.jsonb "title", null: false
    t.bigint "decidim_organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_organization_id"], name: "index_decidim_process_types_on_decidim_organization_id"
  end

  create_table "decidim_participatory_process_user_roles", id: :serial, force: :cascade do |t|
    t.integer "decidim_user_id"
    t.integer "decidim_participatory_process_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_participatory_process_id", "decidim_user_id", "role"], name: "index_unique_user_and_process_role", unique: true
    t.index ["decidim_user_id"], name: "idx_proces_user_role_on_user_id"
  end

  create_table "decidim_participatory_processes", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.string "hashtag"
    t.integer "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "title", null: false
    t.jsonb "subtitle", null: false
    t.jsonb "short_description", null: false
    t.jsonb "description", null: false
    t.string "hero_image"
    t.string "banner_image"
    t.boolean "promoted", default: false
    t.datetime "published_at"
    t.jsonb "developer_group"
    t.date "end_date"
    t.jsonb "meta_scope"
    t.jsonb "local_area"
    t.jsonb "target"
    t.jsonb "participatory_scope"
    t.jsonb "participatory_structure"
    t.integer "decidim_scope_id"
    t.integer "decidim_participatory_process_group_id"
    t.boolean "show_statistics", default: true
    t.jsonb "announcement"
    t.boolean "scopes_enabled", default: true, null: false
    t.date "start_date"
    t.boolean "private_space", default: false
    t.string "reference"
    t.bigint "decidim_area_id"
    t.bigint "decidim_scope_type_id"
    t.boolean "show_metrics", default: true
    t.integer "weight", default: 1, null: false
    t.integer "follows_count", default: 0, null: false
    t.bigint "decidim_participatory_process_type_id"
    t.index ["decidim_area_id"], name: "index_decidim_participatory_processes_on_decidim_area_id"
    t.index ["decidim_organization_id", "slug"], name: "index_unique_process_slug_and_organization", unique: true
    t.index ["decidim_organization_id"], name: "index_decidim_processes_on_decidim_organization_id"
    t.index ["decidim_participatory_process_group_id"], name: "idx_process_on_process_group_id"
    t.index ["decidim_participatory_process_type_id"], name: "index_decidim_processes_on_decidim_process_type_id"
    t.index ["decidim_scope_id"], name: "idx_process_on_scope_id"
    t.index ["decidim_scope_type_id"], name: "index_decidim_participatory_processes_on_decidim_scope_type_id"
  end

  create_table "decidim_participatory_space_links", id: :serial, force: :cascade do |t|
    t.string "from_type", null: false
    t.integer "from_id", null: false
    t.string "to_type", null: false
    t.integer "to_id", null: false
    t.string "name", null: false
    t.jsonb "data"
    t.index ["from_type", "from_id"], name: "index_participatory_space_links_on_from"
    t.index ["name"], name: "index_participatory_space_links_name"
    t.index ["to_type", "to_id"], name: "index_participatory_space_links_on_to"
  end

  create_table "decidim_participatory_space_private_users", force: :cascade do |t|
    t.bigint "decidim_user_id"
    t.integer "privatable_to_id"
    t.string "privatable_to_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_user_id"], name: "index_decidim_spaces_users_on_private_user_id"
    t.index ["privatable_to_type", "privatable_to_id"], name: "space_privatable_to_privatable_id"
  end

  create_table "decidim_plans_plan_collaborator_requests", force: :cascade do |t|
    t.bigint "decidim_plan_id", null: false
    t.bigint "decidim_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_plan_id"], name: "index_plan_collab_requests_on_decidim_plans_plan_id"
    t.index ["decidim_user_id"], name: "index_plan_collab_requests_on_decidim_user_id"
  end

  create_table "decidim_plans_plan_contents", force: :cascade do |t|
    t.jsonb "body", default: []
    t.bigint "decidim_user_id"
    t.bigint "decidim_plan_id"
    t.bigint "decidim_section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_plan_id"], name: "index_decidim_plans_plan_contents_on_decidim_plan_id"
    t.index ["decidim_section_id"], name: "index_decidim_plans_contents_section_id"
    t.index ["decidim_user_id"], name: "index_decidim_plans_plan_contents_on_decidim_user_id"
  end

  create_table "decidim_plans_plans", force: :cascade do |t|
    t.jsonb "title"
    t.integer "position"
    t.string "state"
    t.jsonb "answer"
    t.datetime "answered_at"
    t.integer "coauthorships_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "published_at"
    t.bigint "decidim_component_id", null: false
    t.bigint "decidim_category_id"
    t.bigint "decidim_scope_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "update_token"
    t.datetime "closed_at"
    t.integer "comments_count", default: 0, null: false
    t.integer "follows_count", default: 0, null: false
    t.integer "favorites_count", default: 0, null: false
    t.index ["answered_at"], name: "index_decidim_plans_plans_on_answered_at"
    t.index ["closed_at"], name: "index_decidim_plans_plans_on_closed_at"
    t.index ["decidim_category_id"], name: "index_decidim_plans_plans_on_decidim_category_id"
    t.index ["decidim_component_id"], name: "index_decidim_plans_plans_on_decidim_component_id"
    t.index ["decidim_scope_id"], name: "index_decidim_plans_plans_on_decidim_scope_id"
    t.index ["published_at"], name: "index_decidim_plans_plans_on_published_at"
    t.index ["state"], name: "index_decidim_plans_plans_on_state"
  end

  create_table "decidim_plans_sections", force: :cascade do |t|
    t.integer "position"
    t.jsonb "body"
    t.bigint "decidim_component_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "help"
    t.boolean "mandatory"
    t.string "section_type"
    t.jsonb "settings", default: {}
    t.jsonb "information_label"
    t.jsonb "information"
    t.boolean "visible_form", default: true, null: false
    t.boolean "visible_view", default: true, null: false
    t.boolean "visible_api", default: true, null: false
    t.string "handle"
    t.boolean "searchable", default: false, null: false
    t.jsonb "error_text"
    t.index ["decidim_component_id"], name: "index_decidim_plans_sections_on_decidim_component_id"
    t.index ["position"], name: "index_decidim_plans_sections_on_position"
  end

  create_table "decidim_redirects_redirections", force: :cascade do |t|
    t.bigint "decidim_organization_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "path", null: false
    t.jsonb "parameters"
    t.text "target", null: false
    t.boolean "external", default: false
    t.index ["decidim_organization_id"], name: "index_decidim_redirects_redirections_on_decidim_organization_id"
    t.index ["path"], name: "index_decidim_redirects_redirections_on_path"
    t.index ["priority"], name: "index_decidim_redirects_redirections_on_priority"
  end

  create_table "decidim_reminder_deliveries", force: :cascade do |t|
    t.bigint "decidim_reminder_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_reminder_id"], name: "index_decidim_reminder_deliveries_on_decidim_reminder_id"
  end

  create_table "decidim_reminder_records", force: :cascade do |t|
    t.string "state", default: "active"
    t.string "string", default: "active"
    t.bigint "decidim_reminder_id"
    t.string "remindable_type", null: false
    t.bigint "remindable_id", null: false
    t.index ["decidim_reminder_id"], name: "index_decidim_reminder_records_on_decidim_reminder_id"
    t.index ["remindable_type", "remindable_id"], name: "index_decidim_reminder_records_remindable"
    t.index ["state"], name: "index_decidim_reminder_records_on_state"
    t.index ["string"], name: "index_decidim_reminder_records_on_string"
  end

  create_table "decidim_reminders", force: :cascade do |t|
    t.bigint "decidim_user_id", null: false
    t.bigint "decidim_component_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_component_id"], name: "index_decidim_reminders_on_decidim_component_id"
    t.index ["decidim_user_id"], name: "index_decidim_reminders_on_decidim_user_id"
  end

  create_table "decidim_reports", id: :serial, force: :cascade do |t|
    t.integer "decidim_moderation_id", null: false
    t.integer "decidim_user_id", null: false
    t.string "reason", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locale"
    t.index ["decidim_moderation_id", "decidim_user_id"], name: "decidim_reports_moderation_user_unique", unique: true
    t.index ["decidim_moderation_id"], name: "decidim_reports_moderation"
    t.index ["decidim_user_id"], name: "decidim_reports_user"
  end

  create_table "decidim_resource_links", id: :serial, force: :cascade do |t|
    t.string "from_type", null: false
    t.integer "from_id", null: false
    t.string "to_type", null: false
    t.integer "to_id", null: false
    t.string "name", null: false
    t.jsonb "data"
    t.index ["from_type", "from_id"], name: "index_decidim_resource_links_on_from_type_and_from_id"
    t.index ["name"], name: "index_decidim_resource_links_on_name"
    t.index ["to_type", "to_id"], name: "index_decidim_resource_links_on_to_type_and_to_id"
  end

  create_table "decidim_resource_permissions", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.jsonb "permissions", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_decidim_resource_permissions_on_r_type_and_r_id", unique: true
  end

  create_table "decidim_results_results", id: :serial, force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.integer "decidim_feature_id"
    t.integer "decidim_scope_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.index ["decidim_feature_id"], name: "index_decidim_results_results_on_decidim_feature_id"
    t.index ["decidim_scope_id"], name: "index_decidim_results_results_on_decidim_scope_id"
  end

  create_table "decidim_scope_types", id: :serial, force: :cascade do |t|
    t.integer "decidim_organization_id"
    t.jsonb "name", null: false
    t.jsonb "plural", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_scope_types_on_decidim_organization_id"
  end

  create_table "decidim_scopes", id: :serial, force: :cascade do |t|
    t.integer "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "name", null: false
    t.integer "scope_type_id"
    t.integer "parent_id"
    t.string "code", null: false
    t.integer "part_of", default: [], null: false, array: true
    t.index ["decidim_organization_id", "code"], name: "index_decidim_scopes_on_decidim_organization_id_and_code", unique: true
    t.index ["decidim_organization_id"], name: "index_decidim_scopes_on_decidim_organization_id"
    t.index ["parent_id"], name: "index_decidim_scopes_on_parent_id"
    t.index ["part_of"], name: "index_decidim_scopes_on_part_of", using: :gin
    t.index ["scope_type_id"], name: "index_decidim_scopes_on_scope_type_id"
  end

  create_table "decidim_searchable_resources", force: :cascade do |t|
    t.text "content_a"
    t.text "content_b"
    t.text "content_c"
    t.text "content_d"
    t.string "locale", null: false
    t.datetime "datetime"
    t.bigint "decidim_scope_id"
    t.string "decidim_participatory_space_type"
    t.bigint "decidim_participatory_space_id"
    t.bigint "decidim_organization_id"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_searchable_resources_on_decidim_organization_id"
    t.index ["decidim_participatory_space_type", "decidim_participatory_space_id"], name: "index_decidim_searchable_resource_on_pspace_type_and_pspace_id"
    t.index ["decidim_scope_id"], name: "index_decidim_searchable_resources_on_decidim_scope_id"
    t.index ["resource_type", "resource_id"], name: "index_decidim_searchable_rsrcs_on_s_type_and_s_id"
  end

  create_table "decidim_share_tokens", force: :cascade do |t|
    t.bigint "decidim_organization_id", null: false
    t.bigint "decidim_user_id", null: false
    t.string "token_for_type", null: false
    t.bigint "token_for_id", null: false
    t.string "token", null: false
    t.integer "times_used", default: 0
    t.datetime "created_at"
    t.datetime "last_used_at"
    t.datetime "expires_at"
    t.index ["decidim_organization_id"], name: "index_decidim_share_tokens_on_decidim_organization_id"
    t.index ["decidim_user_id"], name: "index_decidim_share_tokens_on_decidim_user_id"
    t.index ["token_for_type", "token_for_id"], name: "decidim_share_tokens_token_for"
  end

  create_table "decidim_short_links", force: :cascade do |t|
    t.bigint "decidim_organization_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.string "identifier", limit: 10, null: false
    t.string "mounted_engine_name"
    t.string "route_name"
    t.jsonb "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["decidim_organization_id", "identifier"], name: "idx_decidim_short_links_organization_id_identifier", unique: true
    t.index ["decidim_organization_id"], name: "index_decidim_short_links_on_decidim_organization_id"
    t.index ["mounted_engine_name"], name: "index_decidim_short_links_on_mounted_engine_name"
    t.index ["route_name"], name: "index_decidim_short_links_on_route_name"
    t.index ["target_type", "target_id"], name: "index_decidim_short_links_on_target"
  end

  create_table "decidim_static_page_topics", force: :cascade do |t|
    t.jsonb "title", null: false
    t.jsonb "description", null: false
    t.bigint "organization_id", null: false
    t.integer "weight"
    t.boolean "show_in_footer", default: false, null: false
    t.index ["organization_id"], name: "index_decidim_static_page_topics_on_organization_id"
  end

  create_table "decidim_static_pages", id: :serial, force: :cascade do |t|
    t.jsonb "title", null: false
    t.string "slug", null: false
    t.jsonb "content", null: false
    t.integer "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight"
    t.boolean "show_in_footer", default: false, null: false
    t.bigint "topic_id"
    t.boolean "allow_public_access", default: false, null: false
    t.index ["decidim_organization_id"], name: "index_decidim_static_pages_on_decidim_organization_id"
    t.index ["topic_id"], name: "index_decidim_static_pages_on_topic_id"
  end

  create_table "decidim_surveys_surveys", id: :serial, force: :cascade do |t|
    t.integer "decidim_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_component_id"], name: "index_decidim_surveys_surveys_on_decidim_component_id"
  end

  create_table "decidim_system_admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_decidim_system_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_decidim_system_admins_on_reset_password_token", unique: true
  end

  create_table "decidim_tags_taggings", force: :cascade do |t|
    t.bigint "decidim_tags_tag_id", null: false
    t.string "decidim_taggable_type", null: false
    t.bigint "decidim_taggable_id", null: false
    t.datetime "created_at"
    t.index ["decidim_taggable_type", "decidim_taggable_id"], name: "index_on_decidim_tags_taggable"
    t.index ["decidim_tags_tag_id", "decidim_taggable_id", "decidim_taggable_type"], name: "index_uniq_on_tags_tag_and_taggable", unique: true
    t.index ["decidim_tags_tag_id"], name: "index_decidim_tags_taggings_on_decidim_tags_tag_id"
  end

  create_table "decidim_tags_tags", force: :cascade do |t|
    t.jsonb "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "decidim_organization_id", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_tags_tags_on_decidim_organization_id"
  end

  create_table "decidim_templates_templates", force: :cascade do |t|
    t.integer "decidim_organization_id", null: false
    t.string "templatable_type"
    t.bigint "templatable_id"
    t.jsonb "name", null: false
    t.jsonb "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_organization_id"], name: "index_decidim_templates_organization"
    t.index ["templatable_type", "templatable_id"], name: "index_decidim_templates_templatable"
  end

  create_table "decidim_term_customizer_constraints", force: :cascade do |t|
    t.bigint "decidim_organization_id", null: false
    t.string "subject_type"
    t.bigint "subject_id"
    t.bigint "translation_set_id", null: false
    t.index ["decidim_organization_id"], name: "decidim_term_customizer_constraint_organization"
    t.index ["subject_type", "subject_id"], name: "decidim_term_customizer_constraint_subject"
    t.index ["translation_set_id"], name: "decidim_term_customizer_constraint_translation_set"
  end

  create_table "decidim_term_customizer_translation_sets", force: :cascade do |t|
    t.jsonb "name"
  end

  create_table "decidim_term_customizer_translations", force: :cascade do |t|
    t.string "locale"
    t.string "key"
    t.text "value"
    t.bigint "translation_set_id", null: false
    t.index ["translation_set_id"], name: "decidim_term_customizer_translation_translation_set"
  end

  create_table "decidim_user_blocks", force: :cascade do |t|
    t.bigint "decidim_user_id"
    t.integer "blocking_user_id"
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_user_id"], name: "index_decidim_user_blocks_on_decidim_user_id"
  end

  create_table "decidim_user_group_memberships", id: :serial, force: :cascade do |t|
    t.integer "decidim_user_id", null: false
    t.integer "decidim_user_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "requested", null: false
    t.index ["decidim_user_group_id", "decidim_user_id"], name: "index_user_group_memberships_group_id_user_id"
    t.index ["decidim_user_group_id"], name: "index_decidim_user_group_memberships_on_decidim_user_group_id"
    t.index ["decidim_user_id", "decidim_user_group_id"], name: "decidim_user_group_memberships_unique_user_and_group_ids", unique: true
    t.index ["decidim_user_id"], name: "index_decidim_user_group_memberships_on_decidim_user_id"
    t.index ["role", "decidim_user_group_id"], name: "decidim_group_membership_one_creator_per_group", unique: true, where: "((role)::text = 'creator'::text)"
  end

  create_table "decidim_user_moderations", force: :cascade do |t|
    t.bigint "decidim_user_id"
    t.integer "report_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_user_id"], name: "index_decidim_user_moderations_on_decidim_user_id"
  end

  create_table "decidim_user_reports", force: :cascade do |t|
    t.integer "user_moderation_id"
    t.integer "user_id", null: false
    t.string "reason"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decidim_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "decidim_organization_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", null: false
    t.string "locale"
    t.string "avatar"
    t.text "delete_reason"
    t.datetime "deleted_at"
    t.boolean "admin", default: false, null: false
    t.boolean "managed", default: false, null: false
    t.string "roles", default: [], array: true
    t.string "nickname", limit: 20, default: "", null: false
    t.string "personal_url"
    t.text "about"
    t.datetime "accepted_tos_version"
    t.datetime "officialized_at"
    t.jsonb "officialized_as"
    t.string "newsletter_token", default: ""
    t.datetime "newsletter_notifications_at"
    t.string "type", null: false
    t.jsonb "extended_data", default: {}
    t.integer "following_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.string "notification_types", default: "all", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "session_token"
    t.string "direct_message_types", default: "all", null: false
    t.datetime "admin_terms_accepted_at"
    t.boolean "blocked", default: false, null: false
    t.datetime "blocked_at"
    t.integer "block_id"
    t.boolean "email_on_moderations", default: true
    t.integer "follows_count", default: 0, null: false
    t.jsonb "notification_settings", default: {}
    t.string "notifications_sending_frequency", default: "daily"
    t.datetime "digest_sent_at"
    t.datetime "password_updated_at"
    t.string "previous_passwords", default: [], array: true
    t.string "tunnistamo_email_sent_to"
    t.string "tunnistamo_email_code"
    t.datetime "tunnistamo_email_code_sent_at"
    t.integer "tunnistamo_failed_confirmation_attempts", default: 0
    t.index ["confirmation_token"], name: "index_decidim_users_on_confirmation_token", unique: true
    t.index ["decidim_organization_id"], name: "index_decidim_users_on_decidim_organization_id"
    t.index ["email", "decidim_organization_id"], name: "index_decidim_users_on_email_and_decidim_organization_id", unique: true, where: "((deleted_at IS NULL) AND (managed = false) AND ((type)::text = 'Decidim::User'::text))"
    t.index ["id", "type"], name: "index_decidim_users_on_id_and_type"
    t.index ["invitation_token"], name: "index_decidim_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_decidim_users_on_invitations_count"
    t.index ["invited_by_id", "invited_by_type"], name: "index_decidim_users_on_invited_by_id_and_invited_by_type"
    t.index ["invited_by_id"], name: "index_decidim_users_on_invited_by_id"
    t.index ["nickname", "decidim_organization_id"], name: "index_decidim_users_on_nickame_and_decidim_organization_id", unique: true, where: "((deleted_at IS NULL) AND (managed = false))"
    t.index ["notifications_sending_frequency"], name: "index_decidim_users_on_notifications_sending_frequency"
    t.index ["officialized_at"], name: "index_decidim_users_on_officialized_at"
    t.index ["reset_password_token"], name: "index_decidim_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_decidim_users_on_unlock_token", unique: true
  end

  create_table "decidim_verifications_conflicts", force: :cascade do |t|
    t.bigint "current_user_id"
    t.bigint "managed_user_id"
    t.integer "times", default: 0
    t.string "unique_id"
    t.boolean "solved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_user_id"], name: "authorization_current_user"
    t.index ["managed_user_id"], name: "authorization_managed_user"
  end

  create_table "decidim_verifications_csv_data", force: :cascade do |t|
    t.string "email"
    t.bigint "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decidim_organization_id"], name: "index_verifications_csv_census_to_organization"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "organization_name", null: false
    t.string "organization_url", null: false
    t.string "organization_logo"
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.bigint "decidim_organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.boolean "confidential", default: true, null: false
    t.index ["decidim_organization_id"], name: "index_oauth_applications_on_decidim_organization_id"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type", null: false
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.jsonb "comment"
    t.index ["item_id", "item_type"], name: "index_versions_on_item_id_and_item_type"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "decidim_area_types", "decidim_organizations"
  add_foreign_key "decidim_areas", "decidim_area_types", column: "area_type_id"
  add_foreign_key "decidim_areas", "decidim_organizations"
  add_foreign_key "decidim_attachments", "decidim_attachment_collections", column: "attachment_collection_id", name: "fk_decidim_attachments_attachment_collection_id", on_delete: :nullify
  add_foreign_key "decidim_authorizations", "decidim_users"
  add_foreign_key "decidim_categorizations", "decidim_categories"
  add_foreign_key "decidim_editor_images", "decidim_organizations"
  add_foreign_key "decidim_editor_images", "decidim_users", column: "decidim_author_id"
  add_foreign_key "decidim_helsinki_profile_session_infos", "decidim_users"
  add_foreign_key "decidim_identities", "decidim_organizations"
  add_foreign_key "decidim_newsletters", "decidim_users", column: "author_id"
  add_foreign_key "decidim_participatory_process_steps", "decidim_participatory_processes"
  add_foreign_key "decidim_participatory_process_types", "decidim_organizations"
  add_foreign_key "decidim_participatory_processes", "decidim_organizations"
  add_foreign_key "decidim_participatory_processes", "decidim_participatory_process_types"
  add_foreign_key "decidim_participatory_processes", "decidim_scope_types"
  add_foreign_key "decidim_redirects_redirections", "decidim_organizations"
  add_foreign_key "decidim_reminder_deliveries", "decidim_reminders"
  add_foreign_key "decidim_reminder_records", "decidim_reminders"
  add_foreign_key "decidim_reminders", "decidim_components"
  add_foreign_key "decidim_reminders", "decidim_users"
  add_foreign_key "decidim_scope_types", "decidim_organizations"
  add_foreign_key "decidim_scopes", "decidim_organizations"
  add_foreign_key "decidim_scopes", "decidim_scope_types", column: "scope_type_id"
  add_foreign_key "decidim_scopes", "decidim_scopes", column: "parent_id"
  add_foreign_key "decidim_static_pages", "decidim_organizations"
  add_foreign_key "decidim_tags_tags", "decidim_organizations"
  add_foreign_key "decidim_term_customizer_constraints", "decidim_organizations"
  add_foreign_key "decidim_term_customizer_constraints", "decidim_term_customizer_translation_sets", column: "translation_set_id"
  add_foreign_key "decidim_term_customizer_translations", "decidim_term_customizer_translation_sets", column: "translation_set_id"
  add_foreign_key "decidim_user_blocks", "decidim_users"
  add_foreign_key "decidim_user_blocks", "decidim_users", column: "blocking_user_id"
  add_foreign_key "decidim_user_moderations", "decidim_users"
  add_foreign_key "decidim_user_reports", "decidim_user_moderations", column: "user_moderation_id"
  add_foreign_key "decidim_user_reports", "decidim_users", column: "user_id"
  add_foreign_key "decidim_users", "decidim_organizations"
  add_foreign_key "decidim_verifications_conflicts", "decidim_users", column: "current_user_id"
  add_foreign_key "decidim_verifications_conflicts", "decidim_users", column: "managed_user_id"
  add_foreign_key "decidim_verifications_csv_data", "decidim_organizations"
  add_foreign_key "oauth_access_grants", "decidim_users", column: "resource_owner_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "decidim_users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_applications", "decidim_organizations"
end
