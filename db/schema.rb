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

ActiveRecord::Schema[8.1].define(version: 2026_05_19_161417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "city", null: false
    t.string "country_iso", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "label"
    t.string "line1", null: false
    t.string "line2"
    t.string "postal_code", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_variant_id"], name: "index_cart_items_on_cart_id_and_product_variant_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_variant_id"], name: "index_cart_items_on_product_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "guest_uuid", default: -> { "gen_random_uuid()" }
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["guest_uuid"], name: "index_carts_on_guest_uuid", unique: true
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true, where: "(user_id IS NOT NULL)"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "parent_id"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "locale", null: false
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["category_id", "locale"], name: "index_category_translations_on_category_id_and_locale", unique: true
    t.index ["locale", "slug"], name: "index_category_translations_on_locale_and_slug", unique: true
  end

  create_table "line_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "order_id", null: false
    t.string "product_name", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity", null: false
    t.integer "unit_price_cents", null: false
    t.datetime "updated_at", null: false
    t.string "variant_name", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_variant_id"], name: "index_line_items_on_product_variant_id"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "locale", null: false
    t.bigint "translatable_id"
    t.string "translatable_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.string "locale", null: false
    t.bigint "translatable_id"
    t.string "translatable_type"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "guest_email"
    t.string "number", null: false
    t.jsonb "shipping_address_snapshot", default: {}, null: false
    t.string "status", default: "pending", null: false
    t.string "stripe_payment_intent_id"
    t.integer "total_cents", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["stripe_payment_intent_id"], name: "index_orders_on_stripe_payment_intent_id", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["uuid"], name: "index_orders_on_uuid", unique: true
  end

  create_table "product_images", force: :cascade do |t|
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.string "image_url", null: false
    t.integer "position", default: 0, null: false
    t.bigint "product_id", null: false
    t.bigint "product_variant_id"
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
    t.index ["product_variant_id"], name: "index_product_images_on_product_variant_id"
  end

  create_table "product_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "locale", null: false
    t.string "name"
    t.bigint "product_id", null: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["locale", "slug"], name: "index_product_translations_on_locale_and_slug", unique: true
    t.index ["product_id", "locale"], name: "index_product_translations_on_product_id_and_locale", unique: true
  end

  create_table "product_variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "price_cents"
    t.bigint "product_id", null: false
    t.string "sku", null: false
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["sku"], name: "index_product_variants_on_sku", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.integer "base_price_cents", null: false
    t.string "brand"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.boolean "featured", default: false, null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "phone"
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "customer", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "product_variants"
  add_foreign_key "carts", "users"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "category_translations", "categories"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "product_variants"
  add_foreign_key "orders", "users"
  add_foreign_key "product_images", "product_variants"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_translations", "products"
  add_foreign_key "product_variants", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "refresh_tokens", "users"
end
