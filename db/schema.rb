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

ActiveRecord::Schema[7.0].define(version: 20_230_518_170_438) do
  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.integer 'record_id', null: false
    t.integer 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.integer 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'bids', force: :cascade do |t|
    t.integer 'lot_id', null: false
    t.integer 'user_id', null: false
    t.integer 'value'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['lot_id'], name: 'index_bids_on_lot_id'
    t.index ['user_id'], name: 'index_bids_on_user_id'
  end

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'item_categories', force: :cascade do |t|
    t.integer 'item_id', null: false
    t.integer 'category_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_item_categories_on_category_id'
    t.index ['item_id'], name: 'index_item_categories_on_item_id'
  end

  create_table 'item_lots', force: :cascade do |t|
    t.integer 'item_id', null: false
    t.integer 'lot_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'canceled', default: false
    t.index ['item_id'], name: 'index_item_lots_on_item_id'
    t.index ['lot_id'], name: 'index_item_lots_on_lot_id'
  end

  create_table 'items', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.string 'photo'
    t.integer 'weight'
    t.integer 'width'
    t.integer 'height'
    t.integer 'depth'
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'code'
    t.index ['user_id'], name: 'index_items_on_user_id'
  end

  create_table 'lots', force: :cascade do |t|
    t.string 'code'
    t.datetime 'start_date', precision: nil
    t.datetime 'end_date', precision: nil
    t.integer 'minimum_value'
    t.integer 'minimum_difference'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'created_by_id', null: false
    t.integer 'approved_by_id'
    t.integer 'status', default: 2
    t.index ['approved_by_id'], name: 'index_lots_on_approved_by_id'
    t.index ['created_by_id'], name: 'index_lots_on_created_by_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'name'
    t.integer 'sex'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'role', default: 0
    t.string 'social_name'
    t.string 'cpf'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'bids', 'lots'
  add_foreign_key 'bids', 'users'
  add_foreign_key 'item_categories', 'categories'
  add_foreign_key 'item_categories', 'items'
  add_foreign_key 'item_lots', 'items'
  add_foreign_key 'item_lots', 'lots'
  add_foreign_key 'items', 'users'
  add_foreign_key 'lots', 'users', column: 'approved_by_id'
  add_foreign_key 'lots', 'users', column: 'created_by_id'
end
