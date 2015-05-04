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

ActiveRecord::Schema.define(version: 20150504154359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "batters", force: :cascade do |t|
    t.string   "name"
    t.text     "position"
    t.integer  "pa"
    t.integer  "ab"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "triples"
    t.integer  "homers"
    t.integer  "runs"
    t.integer  "rbis"
    t.integer  "walks"
    t.integer  "hbps"
    t.integer  "sb"
    t.integer  "cs"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "fd_salary"
    t.float    "fd_season_ppg"
    t.integer  "pitcher_id"
    t.integer  "team_id"
    t.float    "adj_fd_ppg"
    t.integer  "lineup_spot"
    t.boolean  "selected"
  end

  add_index "batters", ["pitcher_id"], name: "index_batters_on_pitcher_id", using: :btree
  add_index "batters", ["team_id"], name: "index_batters_on_team_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "matchups", force: :cascade do |t|
    t.integer  "visitor_id"
    t.integer  "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "matchups", ["home_id"], name: "index_matchups_on_home_id", using: :btree
  add_index "matchups", ["visitor_id"], name: "index_matchups_on_visitor_id", using: :btree

  create_table "pitchers", force: :cascade do |t|
    t.string   "name"
    t.integer  "wins"
    t.integer  "games"
    t.integer  "gs"
    t.integer  "ip"
    t.integer  "er"
    t.integer  "so"
    t.float    "whip"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "fd_salary"
    t.float    "fd_season_ppg"
    t.boolean  "starting",      default: false
    t.integer  "homers"
    t.integer  "hits"
    t.integer  "team_id"
    t.boolean  "selected"
  end

  add_index "pitchers", ["team_id"], name: "index_pitchers_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
