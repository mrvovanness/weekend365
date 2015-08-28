# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150828171711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "mark"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "office_address"
    t.string   "country"
    t.text     "description"
    t.string   "website"
    t.integer  "employees_number"
    t.integer  "employees_registered"
    t.integer  "user_id"
    t.integer  "company_field_id"
  end

  add_index "companies", ["company_field_id"], name: "index_companies_on_company_field_id", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_fields", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_surveys", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "title"
    t.string   "state"
    t.integer  "number_of_responses", default: 0
    t.boolean  "alarm",               default: false
    t.boolean  "repeat"
    t.date     "start_on"
    t.date     "finish_on"
    t.integer  "number_of_repeats"
    t.datetime "next_delivery_at"
    t.text     "message"
    t.integer  "repeat_every"
    t.string   "repeat_mode"
    t.integer  "counter",             default: 0
    t.datetime "start_at"
  end

  add_index "company_surveys", ["company_id"], name: "index_company_surveys_on_company_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "department"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "position"
    t.boolean  "selected_to_survey", default: false
    t.string   "email"
    t.integer  "company_id"
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree

  create_table "employees_surveys", id: false, force: :cascade do |t|
    t.integer "employee_id"
    t.integer "survey_id"
  end

  add_index "employees_surveys", ["employee_id"], name: "index_employees_surveys_on_employee_id", using: :btree
  add_index "employees_surveys", ["survey_id"], name: "index_employees_surveys_on_survey_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string   "name"
    t.boolean  "expired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
