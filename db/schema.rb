# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_10_12_064914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_histories", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.bigint "user_id", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_application_histories_on_application_id"
    t.index ["user_id"], name: "index_application_histories_on_user_id"
  end

  create_table "applications", force: :cascade do |t|
    t.uuid "reference_id"
    t.string "submission_id"
    t.bigint "user_id"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "place_of_birth"
    t.string "gender"
    t.string "country"
    t.string "email"
    t.string "country_code"
    t.string "mobile"
    t.string "passport_number"
    t.string "passport_place_of_issue"
    t.string "passport_date_of_issue"
    t.string "passport_expiry_date"
    t.string "intented_date_of_entry"
    t.boolean "is_other_nationality"
    t.string "other_nationality"
    t.string "year_of_acquistion"
    t.string "photo"
    t.string "passport_photo_front"
    t.string "passport_photo_back"
    t.string "visa_fee"
    t.string "service_fee"
    t.integer "status", default: 0
    t.integer "payment_status", default: 0
    t.string "payment_reference_number"
    t.datetime "submitted_on"
    t.datetime "visa_applied_at"
    t.bigint "visa_applied_by_id"
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.string "approval_document"
    t.datetime "rejected_at"
    t.bigint "rejected_by_id"
    t.string "rejection_note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approved_by_id"], name: "index_applications_on_approved_by_id"
    t.index ["rejected_by_id"], name: "index_applications_on_rejected_by_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
    t.index ["visa_applied_by_id"], name: "index_applications_on_visa_applied_by_id"
  end

  create_table "login_accounts", force: :cascade do |t|
    t.string "type"
    t.json "auth_hash"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_login_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password"
    t.string "name"
    t.integer "role", default: 0
    t.string "designation"
    t.string "profile"
    t.string "company_name"
    t.string "mobile_number"
    t.integer "status", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "application_histories", "applications"
  add_foreign_key "application_histories", "users"
end
