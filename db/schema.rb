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

ActiveRecord::Schema[8.0].define(version: 2025_02_19_083721) do
  create_table "activities", force: :cascade do |t|
    t.integer "admin_id"
    t.string "name", null: false
    t.string "description"
    t.integer "category", null: false
    t.integer "frequency", null: false
    t.integer "repetition", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_activities_on_admin_id"
    t.index ["name"], name: "index_activities_on_name", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_admins_on_email_address", unique: true
  end

  create_table "program_activities", force: :cascade do |t|
    t.integer "program_id", null: false
    t.integer "activity_id", null: false
    t.integer "frequency"
    t.integer "repetition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_program_activities_on_activity_id"
    t.index ["program_id", "activity_id"], name: "index_program_activities_on_program_id_and_activity_id", unique: true
    t.index ["program_id"], name: "index_program_activities_on_program_id"
  end

  create_table "programs", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "user_id"
    t.string "title"
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_programs_on_admin_id"
    t.index ["user_id"], name: "index_programs_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "resource_type", null: false
    t.integer "resource_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_sessions_on_resource"
    t.index ["resource_type", "resource_id"], name: "index_sessions_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end
end
