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

ActiveRecord::Schema[7.0].define(version: 2026_06_03_131254) do
  # These are extensions that must be enabled in order to support this database
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "cuit"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cuit"], name: "index_customers_on_cuit", unique: true
  end

  create_table "destinations", force: :cascade do |t|
    t.string "cuit"
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.string "phone_number"
    t.string "location"
    t.string "cuit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "licencia_vencimiento"
    t.boolean "aptofisico"
    t.date "apto_vencimiento"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "province"
    t.float "longitude"
    t.float "latitude"
    t.index ["customer_id"], name: "index_fields_on_customer_id"
  end

  create_table "gastos", force: :cascade do |t|
    t.bigint "imputation_id", null: false
    t.string "supplier"
    t.string "description"
    t.bigint "driver_id"
    t.bigint "truck_id"
    t.date "date"
    t.float "total"
    t.float "net"
    t.float "iva"
    t.float "gravado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "truck_disabled"
    t.boolean "driver_disabled"
    t.index ["driver_id"], name: "index_gastos_on_driver_id"
    t.index ["imputation_id"], name: "index_gastos_on_imputation_id"
    t.index ["truck_id"], name: "index_gastos_on_truck_id"
  end

  create_table "imputations", force: :cascade do |t|
    t.string "imputation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.bigint "truck_id", null: false
    t.date "date"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["truck_id"], name: "index_services_on_truck_id"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "field_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "destination_id", null: false
    t.bigint "driver_id", null: false
    t.bigint "truck_id", null: false
    t.float "weight"
    t.string "product"
    t.date "date"
    t.float "kilometres"
    t.float "tariff"
    t.float "net"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "importeiva"
    t.boolean "estado"
    t.date "date_end"
    t.index ["customer_id"], name: "index_trips_on_customer_id"
    t.index ["destination_id"], name: "index_trips_on_destination_id"
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["field_id"], name: "index_trips_on_field_id"
    t.index ["truck_id"], name: "index_trips_on_truck_id"
  end

  create_table "truck_services", force: :cascade do |t|
    t.bigint "truck_id", null: false
    t.date "service_date"
    t.float "kilometres_at_service"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["truck_id"], name: "index_truck_services_on_truck_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "plate"
    t.string "brand"
    t.string "model"
    t.float "capacity"
    t.string "fuel"
    t.float "kilometres"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "service_kilometres"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "surname"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fields", "customers"
  add_foreign_key "gastos", "drivers"
  add_foreign_key "gastos", "imputations"
  add_foreign_key "gastos", "trucks"
  add_foreign_key "services", "trucks"
  add_foreign_key "trips", "customers"
  add_foreign_key "trips", "destinations"
  add_foreign_key "trips", "drivers"
  add_foreign_key "trips", "fields"
  add_foreign_key "trips", "trucks"
  add_foreign_key "truck_services", "trucks"
end
