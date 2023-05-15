# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
# e
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_15_221939) do
  create_table "carbon_footprint_log", primary_key: "carbon_footprint_log_id", force: :cascade do |t|
    t.integer "producer_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, default: "\x00", null: false
    t.boolean "active", default: true, null: false
    t.decimal "score", precision: 12, scale: 4, null: false
  end

  create_table "certificates", primary_key: "certificate_id", id: :integer, force: :cascade do |t|
    t.integer "producer_id", null: false
    t.varchar "name", limit: 255, null: false
    t.varchar "description", limit: 255, null: false
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil, null: false
  end

  create_table "certificates_have_trash_types", primary_key: ["certificate_id", "trash_type_id"], force: :cascade do |t|
    t.integer "certificate_id", null: false
    t.integer "trash_type_id", null: false
  end

  create_table "cities", primary_key: "city_id", id: :integer, force: :cascade do |t|
    t.integer "province_id", null: false
    t.varchar "name", limit: 255, null: false
  end

  create_table "collection_log", primary_key: "collection_log_id", force: :cascade do |t|
    t.integer "collection_point_id", null: false
    t.integer "service_contract_id", null: false
    t.datetime "datetime", precision: nil, null: false
    t.integer "responsible_person_id", null: false
    t.integer "fleet_id"
    t.integer "company_id"
    t.integer "producer_id"
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, null: false
  end

  create_table "collection_points", primary_key: "collection_point_id", id: :integer, force: :cascade do |t|
    t.integer "location_id", null: false
    t.varchar "name", limit: 255, null: false
    t.integer "producer_id"
    t.integer "company_id"
    t.boolean "is_dropoff", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "companies", primary_key: "company_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "companies_have_people", primary_key: ["company_id", "person_id"], force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "person_id", null: false
  end

  create_table "companies_have_regions", primary_key: ["company_id", "region_id"], force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "region_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "contact_info_types", primary_key: "contact_info_type_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "countries", primary_key: "country_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "currencies", primary_key: "currency_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.varchar "symbol", limit: 10, null: false
  end

  create_table "currencies_dollar_exchange_rate_log", primary_key: "currency_dollar_exchange_rate_log_id", force: :cascade do |t|
    t.integer "currency_id", null: false
    t.decimal "exchange_rate", precision: 12, scale: 4, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "start_date", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "end_date", precision: nil
    t.boolean "active", default: true, null: false
    t.varbinary "checksum", limit: 64, default: "\x00", null: false
  end

  create_table "eventTypes", primary_key: "eventType_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 20, null: false
  end

  create_table "eventlog", primary_key: "eventlog_id", force: :cascade do |t|
    t.integer "level_id", null: false
    t.datetime "eventdate", precision: nil, null: false
    t.integer "eventtype", null: false
    t.integer "source_id", null: false
    t.varbinary "checksum", limit: 32, null: false
    t.varchar "username", limit: 20, null: false
    t.bigint "referenceId1", null: false
    t.bigint "referenceId2", null: false
    t.varchar "value1", limit: 60, null: false
    t.varchar "value2", limit: 60, null: false
  end

  create_table "fleets", primary_key: "fleet_id", id: :integer, force: :cascade do |t|
    t.varchar "plate", limit: 255, null: false
    t.decimal "capacity", precision: 10, scale: 3, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "flyway_schema_history", primary_key: "installed_rank", id: :integer, default: nil, force: :cascade do |t|
    t.string "version", limit: 50
    t.string "description", limit: 200
    t.string "type", limit: 20, null: false
    t.string "script", limit: 1000, null: false
    t.integer "checksum"
    t.string "installed_by", limit: 100, null: false
    t.datetime "installed_on", precision: nil, default: -> { "getdate()" }, null: false
    t.integer "execution_time", null: false
    t.boolean "success", null: false
    t.index ["success"], name: "flyway_schema_history_s_idx"
  end

  create_table "frequencies", primary_key: "frequency_id", id: :integer, force: :cascade do |t|
    t.varchar "frequency", limit: 255, null: false
  end

  create_table "invoices", primary_key: "invoice_id", id: :integer, force: :cascade do |t|
    t.integer "producer_id", null: false
    t.varchar "invoice_number", limit: 255, null: false
    t.datetime "invoice_date", precision: nil, null: false
    t.datetime "invoice_due_date", precision: nil, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, null: false
    t.decimal "invoice_amount", precision: 12, scale: 4, null: false
    t.integer "currency_id", null: false
  end

  create_table "languages", primary_key: "language_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.varchar "code", limit: 10, null: false
  end

  create_table "levels", primary_key: "level_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 20, null: false
  end

  create_table "locations", primary_key: "location_id", id: :integer, force: :cascade do |t|
    t.integer "city_id", null: false
    t.varchar "name", limit: 255, null: false
    t.string "coordinates", null: false
    t.varchar "zipcode", limit: 255, null: false
  end

  create_table "materialXwaste_type", primary_key: "materialXwaste_type_id", id: :integer, force: :cascade do |t|
    t.integer "material_id", null: false
    t.integer "trash_type_id", null: false
    t.decimal "kg_conversion", precision: 12, scale: 4, null: false
  end

  create_table "materials", primary_key: "material_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "materialsXproducts", primary_key: "materialsXproducts_id", id: :integer, force: :cascade do |t|
    t.integer "material_id", null: false
    t.integer "product_id", null: false
    t.decimal "quantity", precision: 12, scale: 4, null: false
    t.integer "measure_id", null: false
  end

  create_table "measures", primary_key: "measure_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "movement_types", primary_key: "movement_type_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "objectTypes", primary_key: "objectType_id", force: :cascade do |t|
    t.varchar "name", limit: 20, null: false
  end

  create_table "payments", primary_key: "payment_id", id: :integer, force: :cascade do |t|
    t.integer "transaction_id", null: false
    t.datetime "payment_date", precision: nil, null: false
    t.integer "producer_id", null: false
    t.integer "invoice_id", null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, null: false
  end

  create_table "people", primary_key: "person_id", id: :integer, force: :cascade do |t|
    t.varchar "full_name", limit: 255, null: false
  end

  create_table "people_have_contact_info_types", primary_key: ["person_id", "contact_info_type_id"], force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "contact_info_type_id", null: false
    t.varchar "value", limit: 255, null: false
  end

  create_table "percentages", primary_key: "percentage_id", id: :integer, force: :cascade do |t|
    t.integer "fleet_id"
    t.integer "company_id"
    t.integer "producer_id"
    t.varchar "name", limit: 255, null: false
    t.decimal "percentage", precision: 12, scale: 4, null: false
    t.integer "recycling_contract_id", null: false
  end

  create_table "processing_cost_per_waste_type", primary_key: "processing_cost_per_waste_type_id", id: :integer, force: :cascade do |t|
    t.integer "trash_type_id", null: false
    t.decimal "cost", precision: 12, scale: 4, null: false
    t.integer "currency_id", null: false
    t.integer "recycling_contract_id", null: false
  end

  create_table "produced_products_log", primary_key: "produced_products_log_id", id: :integer, force: :cascade do |t|
    t.integer "product_id", null: false
    t.decimal "quantity", precision: 12, scale: 4, null: false
    t.integer "measure_id", null: false
    t.integer "recycling_contract_id", null: false
  end

  create_table "producer_parents", primary_key: "producer_parent_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "producer_parents_have_people", primary_key: ["producer_parent_id", "person_id"], force: :cascade do |t|
    t.integer "producer_parent_id", null: false
    t.integer "person_id", null: false
  end

  create_table "producers", primary_key: "producer_id", id: :integer, force: :cascade do |t|
    t.integer "producer_parent_id"
    t.varchar "name", limit: 255, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "producers_have_people", primary_key: ["producer_id", "person_id"], force: :cascade do |t|
    t.integer "producer_id", null: false
    t.integer "person_id", null: false
  end

  create_table "product_price_log", primary_key: "product_price_log_id", id: :integer, force: :cascade do |t|
    t.integer "product_id", null: false
    t.decimal "price", precision: 12, scale: 4, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, default: "\x00", null: false
    t.integer "currency_id", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "products", primary_key: "product_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.decimal "kg_to_produce", precision: 12, scale: 4, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "provinces", primary_key: "province_id", id: :integer, force: :cascade do |t|
    t.integer "country_id", null: false
    t.varchar "name", limit: 255, null: false
  end

  create_table "recipient_brands", primary_key: "recipient_brand_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "recipient_log", primary_key: "recipient_log_id", force: :cascade do |t|
    t.integer "recipient_id", null: false
    t.integer "recipient_status_id", default: 1, null: false
    t.bigint "collection_log_id", null: false
    t.integer "movement_type_id", null: false
    t.integer "trash_type_id", null: false
    t.datetime "datetime", precision: nil, null: false
    t.decimal "weight", precision: 12, scale: 4
  end

  create_table "recipient_models", primary_key: "recipient_model_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.decimal "weight_capacity", precision: 12, scale: 4, null: false
    t.integer "brand_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "recipient_status", primary_key: "recipient_status_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "recipient_types", primary_key: "recipient_type_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.integer "recipient_model_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "recipient_types_have_trash_types", primary_key: ["recipient_type_id", "trash_type_id"], force: :cascade do |t|
    t.integer "recipient_type_id", null: false
    t.integer "trash_type_id", null: false
  end

  create_table "recipients", primary_key: "recipient_id", id: :integer, force: :cascade do |t|
    t.integer "recipient_type_id", null: false
    t.integer "producer_id", null: false
    t.integer "recipient_status_id", default: 1, null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "recycling_contracts", primary_key: "recycling_contract_id", id: :integer, force: :cascade do |t|
    t.varbinary "checksum", limit: 64, default: "\x00", null: false
    t.datetime "valid_from", precision: nil, null: false
    t.datetime "valid_to", precision: nil, null: false
    t.integer "service_contract_id", null: false
  end

  create_table "region_areas", primary_key: "region_area_id", id: :integer, force: :cascade do |t|
    t.integer "region_id", null: false
    t.integer "city_id"
    t.integer "province_id"
    t.integer "country_id"
  end

  create_table "regions", primary_key: "region_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
  end

  create_table "sales", primary_key: "sale_id", id: :integer, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "recycling_contract_id", null: false
    t.datetime "datetime", precision: nil, default: -> { "getdate()" }, null: false
  end

  create_table "schedule_log", primary_key: "schedule_log_id", force: :cascade do |t|
    t.integer "fleet_id"
    t.integer "company_id"
    t.integer "producer_id"
    t.integer "collection_point_id"
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil, null: false
    t.integer "service_contract_id", null: false
    t.integer "movement_type_id", null: false
    t.integer "frequency_id", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "schedule_logs_have_recipient_types", primary_key: ["schedule_log_id", "recipient_type_id"], force: :cascade do |t|
    t.bigint "schedule_log_id", null: false
    t.integer "recipient_type_id", null: false
    t.decimal "expected_amount", precision: 12, scale: 4, null: false
  end

  create_table "service_contracts", primary_key: "service_contract_id", id: :integer, force: :cascade do |t|
    t.integer "producer_id", null: false
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil, null: false
    t.varbinary "checksum", limit: 64, default: "\x00", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.boolean "active", default: true, null: false
  end

  create_table "sources", primary_key: "source_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 20, null: false
  end

  create_table "sponsor_producers_per_region", primary_key: "sponsor_producer_per_region_id", id: :integer, force: :cascade do |t|
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil, null: false
    t.integer "service_contract_id", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, null: false
    t.boolean "active", default: true, null: false
    t.decimal "percentage", precision: 12, scale: 4, null: false
    t.integer "producer_id", null: false
    t.integer "region_id", null: false
  end

  create_table "transactions", primary_key: "transaction_id", id: :integer, force: :cascade do |t|
    t.datetime "transaction_date", precision: nil, null: false
    t.decimal "payment_amount", precision: 12, scale: 4, null: false
    t.integer "currency_id", null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
    t.varbinary "checksum", limit: 64, null: false
  end

  create_table "translations", primary_key: "translation_id", id: :integer, force: :cascade do |t|
    t.varchar "label", limit: 255, null: false
    t.bigint "reference_id", null: false
    t.datetime "post_time", precision: nil, null: false
    t.boolean "active", default: true, null: false
    t.integer "language_id", null: false
    t.bigint "objectType_id", null: false
  end

  create_table "trash_types", primary_key: "trash_type_id", id: :integer, force: :cascade do |t|
    t.varchar "name", limit: 255, null: false
    t.boolean "is_recyclable", null: false
    t.datetime "created_at", precision: nil, default: -> { "getdate()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "getdate()" }, null: false
  end

  add_foreign_key "carbon_footprint_log", "producers", primary_key: "producer_id", name: "FK__carbon_fo__produ__22401542"
  add_foreign_key "certificates", "producers", primary_key: "producer_id", name: "FK__certifica__produ__3587F3E0"
  add_foreign_key "certificates_have_trash_types", "certificates", primary_key: "certificate_id", name: "FK__certifica__certi__251C81ED"
  add_foreign_key "certificates_have_trash_types", "trash_types", primary_key: "trash_type_id", name: "FK__certifica__trash__2610A626"
  add_foreign_key "cities", "provinces", primary_key: "province_id", name: "FK__cities__province__6E01572D"
  add_foreign_key "collection_log", "collection_points", primary_key: "collection_point_id", name: "FK__collectio__colle__2DE6D218"
  add_foreign_key "collection_log", "companies", primary_key: "company_id", name: "FK__collectio__compa__2FCF1A8A"
  add_foreign_key "collection_log", "fleets", primary_key: "fleet_id", name: "FK__collectio__fleet__2EDAF651"
  add_foreign_key "collection_log", "people", column: "responsible_person_id", primary_key: "person_id", name: "FK__collectio__respo__32AB8735"
  add_foreign_key "collection_log", "producers", primary_key: "producer_id", name: "FK__collectio__produ__30C33EC3"
  add_foreign_key "collection_log", "service_contracts", primary_key: "service_contract_id", name: "FK__collectio__servi__31B762FC"
  add_foreign_key "collection_points", "companies", primary_key: "company_id", name: "FK__collectio__compa__75A278F5"
  add_foreign_key "collection_points", "locations", primary_key: "location_id", name: "FK__collectio__locat__73BA3083"
  add_foreign_key "collection_points", "producers", primary_key: "producer_id", name: "FK__collectio__produ__74AE54BC"
  add_foreign_key "companies_have_people", "companies", primary_key: "company_id", name: "FK__companies__compa__282DF8C2"
  add_foreign_key "companies_have_people", "people", primary_key: "person_id", name: "FK__companies__perso__29221CFB"
  add_foreign_key "companies_have_regions", "companies", primary_key: "company_id", name: "FK__companies__compa__1DB06A4F"
  add_foreign_key "companies_have_regions", "regions", primary_key: "region_id", name: "FK__companies__regio__1EA48E88"
  add_foreign_key "currencies_dollar_exchange_rate_log", "currencies", primary_key: "currency_id", name: "FK__currencie__curre__66603565"
  add_foreign_key "eventlog", "eventTypes", column: "eventtype", primary_key: "eventType_id", name: "FK__eventlog__eventt__04AFB25B"
  add_foreign_key "eventlog", "levels", primary_key: "level_id", name: "FK__eventlog__level___01D345B0"
  add_foreign_key "eventlog", "objectTypes", column: "referenceId1", primary_key: "objectType_id", name: "FK__eventlog__refere__02C769E9"
  add_foreign_key "eventlog", "objectTypes", column: "referenceId2", primary_key: "objectType_id", name: "FK__eventlog__refere__03BB8E22"
  add_foreign_key "eventlog", "sources", primary_key: "source_id", name: "FK__eventlog__source__00DF2177"
  add_foreign_key "invoices", "currencies", primary_key: "currency_id", name: "FK__invoices__curren__10216507"
  add_foreign_key "invoices", "producers", primary_key: "producer_id", name: "FK__invoices__produc__0F2D40CE"
  add_foreign_key "locations", "cities", primary_key: "city_id", name: "FK__locations__city___70DDC3D8"
  add_foreign_key "materialXwaste_type", "materials", primary_key: "material_id", name: "FK__materialX__mater__5AB9788F"
  add_foreign_key "materialXwaste_type", "trash_types", primary_key: "trash_type_id", name: "FK__materialX__trash__5BAD9CC8"
  add_foreign_key "materialsXproducts", "materials", primary_key: "material_id", name: "FK__materials__mater__51300E55"
  add_foreign_key "materialsXproducts", "measures", primary_key: "measure_id", name: "FK__materials__measu__5224328E"
  add_foreign_key "materialsXproducts", "products", primary_key: "product_id", name: "FK__materials__produ__531856C7"
  add_foreign_key "payments", "invoices", primary_key: "invoice_id", name: "FK__payments__invoic__17C286CF"
  add_foreign_key "payments", "producers", primary_key: "producer_id", name: "FK__payments__produc__18B6AB08"
  add_foreign_key "payments", "transactions", primary_key: "transaction_id", name: "FK__payments__transa__16CE6296"
  add_foreign_key "people_have_contact_info_types", "contact_info_types", primary_key: "contact_info_type_id", name: "FK__people_ha__conta__0F624AF8"
  add_foreign_key "people_have_contact_info_types", "people", primary_key: "person_id", name: "FK__people_ha__perso__0E6E26BF"
  add_foreign_key "percentages", "recycling_contracts", primary_key: "recycling_contract_id", name: "FK__percentag__recyc__634EBE90"
  add_foreign_key "processing_cost_per_waste_type", "currencies", primary_key: "currency_id", name: "FK__processin__curre__57DD0BE4"
  add_foreign_key "processing_cost_per_waste_type", "recycling_contracts", primary_key: "recycling_contract_id", name: "FK__processin__recyc__55F4C372"
  add_foreign_key "processing_cost_per_waste_type", "trash_types", primary_key: "trash_type_id", name: "FK__processin__trash__56E8E7AB"
  add_foreign_key "produced_products_log", "measures", primary_key: "measure_id", name: "FK__produced___measu__5F7E2DAC"
  add_foreign_key "produced_products_log", "products", primary_key: "product_id", name: "FK__produced___produ__5E8A0973"
  add_foreign_key "produced_products_log", "recycling_contracts", primary_key: "recycling_contract_id", name: "FK__produced___recyc__607251E5"
  add_foreign_key "producer_parents_have_people", "people", primary_key: "person_id", name: "FK__producer___perso__1332DBDC"
  add_foreign_key "producer_parents_have_people", "producer_parents", primary_key: "producer_parent_id", name: "FK__producer___produ__123EB7A3"
  add_foreign_key "producers", "producer_parents", primary_key: "producer_parent_id", name: "FK__producers__produ__412EB0B6"
  add_foreign_key "producers_have_people", "people", primary_key: "person_id", name: "FK__producers__perso__25518C17"
  add_foreign_key "producers_have_people", "producers", primary_key: "producer_id", name: "FK__producers__produ__245D67DE"
  add_foreign_key "product_price_log", "currencies", primary_key: "currency_id", name: "FK__product_p__curre__345EC57D"
  add_foreign_key "product_price_log", "products", primary_key: "product_id", name: "FK__product_p__produ__336AA144"
  add_foreign_key "provinces", "countries", primary_key: "country_id", name: "FK__provinces__count__6B24EA82"
  add_foreign_key "recipient_log", "collection_log", primary_key: "collection_log_id", name: "FK__recipient__colle__73852659"
  add_foreign_key "recipient_log", "movement_types", primary_key: "movement_type_id", name: "FK__recipient__movem__76619304"
  add_foreign_key "recipient_log", "recipient_status", primary_key: "recipient_status_id", name: "FK__recipient__recip__756D6ECB"
  add_foreign_key "recipient_log", "recipients", primary_key: "recipient_id", name: "FK__recipient__recip__74794A92"
  add_foreign_key "recipient_log", "trash_types", primary_key: "trash_type_id", name: "FK__recipient__trash__72910220"
  add_foreign_key "recipient_models", "recipient_brands", column: "brand_id", primary_key: "recipient_brand_id", name: "FK__recipient__brand__3E1D39E1"
  add_foreign_key "recipient_types", "recipient_models", primary_key: "recipient_model_id", name: "FK__recipient__recip__40F9A68C"
  add_foreign_key "recipient_types_have_trash_types", "recipient_types", primary_key: "recipient_type_id", name: "FK__recipient__recip__45BE5BA9"
  add_foreign_key "recipient_types_have_trash_types", "trash_types", primary_key: "trash_type_id", name: "FK__recipient__trash__46B27FE2"
  add_foreign_key "recipients", "producers", primary_key: "producer_id", name: "FK__recipient__produ__6AEFE058"
  add_foreign_key "recipients", "recipient_status", primary_key: "recipient_status_id", name: "FK__recipient__recip__6CD828CA"
  add_foreign_key "recipients", "recipient_types", primary_key: "recipient_type_id", name: "FK__recipient__recip__6BE40491"
  add_foreign_key "recycling_contracts", "service_contracts", primary_key: "service_contract_id", name: "FK__recycling__servi__4A8310C6"
  add_foreign_key "region_areas", "cities", primary_key: "city_id", name: "FK__region_ar__city___09A971A2"
  add_foreign_key "region_areas", "countries", primary_key: "country_id", name: "FK__region_ar__count__0B91BA14"
  add_foreign_key "region_areas", "provinces", primary_key: "province_id", name: "FK__region_ar__provi__0A9D95DB"
  add_foreign_key "region_areas", "regions", primary_key: "region_id", name: "FK__region_ar__regio__08B54D69"
  add_foreign_key "sales", "products", primary_key: "product_id", name: "FK__sales__product_i__382F5661"
  add_foreign_key "sales", "recycling_contracts", primary_key: "recycling_contract_id", name: "FK__sales__recycling__39237A9A"
  add_foreign_key "schedule_log", "collection_points", primary_key: "collection_point_id", name: "FK__schedule___colle__00200768"
  add_foreign_key "schedule_log", "companies", primary_key: "company_id", name: "FK__schedule___compa__7F2BE32F"
  add_foreign_key "schedule_log", "fleets", primary_key: "fleet_id", name: "FK__schedule___fleet__7C4F7684"
  add_foreign_key "schedule_log", "frequencies", primary_key: "frequency_id", name: "FK__schedule___frequ__7D439ABD"
  add_foreign_key "schedule_log", "movement_types", primary_key: "movement_type_id", name: "FK__schedule___movem__02084FDA"
  add_foreign_key "schedule_log", "producers", primary_key: "producer_id", name: "FK__schedule___produ__7E37BEF6"
  add_foreign_key "schedule_log", "service_contracts", primary_key: "service_contract_id", name: "FK__schedule___servi__01142BA1"
  add_foreign_key "schedule_logs_have_recipient_types", "recipient_types", primary_key: "recipient_type_id", name: "FK__schedule___recip__1C873BEC"
  add_foreign_key "schedule_logs_have_recipient_types", "schedule_log", primary_key: "schedule_log_id", name: "FK__schedule___sched__1B9317B3"
  add_foreign_key "service_contracts", "producers", primary_key: "producer_id", name: "FK__service_c__produ__5FB337D6"
  add_foreign_key "service_contracts", "service_contracts", primary_key: "service_contract_id", name: "FK__service_c__servi__5EBF139D"
  add_foreign_key "sponsor_producers_per_region", "producers", primary_key: "producer_id", name: "FK__sponsor_p__produ__2DB1C7EE"
  add_foreign_key "sponsor_producers_per_region", "regions", primary_key: "region_id", name: "FK__sponsor_p__regio__2CBDA3B5"
  add_foreign_key "sponsor_producers_per_region", "service_contracts", primary_key: "service_contract_id", name: "FK__sponsor_p__servi__2BC97F7C"
  add_foreign_key "translations", "languages", primary_key: "language_id", name: "FK__translati__langu__0A688BB1"
  add_foreign_key "translations", "objectTypes", primary_key: "objectType_id", name: "FK__translati__objec__0B5CAFEA"
end
