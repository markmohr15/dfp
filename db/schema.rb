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

ActiveRecord::Schema.define(version: 20150627194936) do

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
    t.integer  "zips_pa"
    t.integer  "zips_ab"
    t.integer  "zips_hits"
    t.integer  "zips_doubles"
    t.integer  "zips_triples"
    t.integer  "zips_homers"
    t.integer  "zips_runs"
    t.integer  "zips_rbis"
    t.integer  "zips_walks"
    t.integer  "zips_hbps"
    t.integer  "zips_sb"
    t.integer  "zips_cs"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "fd_salary"
    t.float    "fd_season_ppg"
    t.integer  "pitcher_id"
    t.integer  "team_id"
    t.float    "zips_adj_fd_ppg"
    t.integer  "lineup_spot"
    t.boolean  "selected"
    t.integer  "rh_overnight_lineup_spot"
    t.integer  "lh_overnight_lineup_spot"
    t.integer  "zips_pa_rhp"
    t.integer  "zips_ab_rhp"
    t.integer  "zips_hits_rhp"
    t.integer  "zips_doubles_rhp"
    t.integer  "zips_triples_rhp"
    t.integer  "zips_homers_rhp"
    t.integer  "zips_rbis_rhp"
    t.integer  "zips_walks_rhp"
    t.integer  "zips_hbps_rhp"
    t.integer  "zips_pa_lhp"
    t.integer  "zips_ab_lhp"
    t.integer  "zips_hits_lhp"
    t.integer  "zips_doubles_lhp"
    t.integer  "zips_triples_lhp"
    t.integer  "zips_homers_lhp"
    t.integer  "zips_rbis_lhp"
    t.integer  "zips_walks_lhp"
    t.integer  "zips_hbps_lhp"
    t.integer  "pa_rhp"
    t.integer  "ab_rhp"
    t.integer  "hits_rhp"
    t.integer  "doubles_rhp"
    t.integer  "triples_rhp"
    t.integer  "homers_rhp"
    t.integer  "rbis_rhp"
    t.integer  "walks_rhp"
    t.integer  "hbps_rhp"
    t.integer  "pa_lhp"
    t.integer  "ab_lhp"
    t.integer  "hits_lhp"
    t.integer  "doubles_lhp"
    t.integer  "triples_lhp"
    t.integer  "homers_lhp"
    t.integer  "rbis_lhp"
    t.integer  "walks_lhp"
    t.integer  "hbps_lhp"
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
    t.string   "fd_alias"
    t.string   "fg_alias"
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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "visiting_pitcher_id"
    t.integer  "home_pitcher_id"
    t.date     "day"
    t.integer  "pin_vis_close"
    t.integer  "pin_home_close"
  end

  add_index "matchups", ["home_id"], name: "index_matchups_on_home_id", using: :btree
  add_index "matchups", ["visitor_id"], name: "index_matchups_on_visitor_id", using: :btree

  create_table "pitchers", force: :cascade do |t|
    t.string   "name"
    t.integer  "zips_wins"
    t.integer  "zips_games"
    t.integer  "zips_gs"
    t.integer  "zips_ip"
    t.integer  "zips_er"
    t.integer  "zips_so"
    t.float    "zips_whip"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "fd_salary"
    t.float    "fd_season_ppg"
    t.boolean  "reliever",       default: false
    t.integer  "zips_homers"
    t.integer  "zips_hits"
    t.integer  "team_id"
    t.boolean  "selected"
    t.float    "sierra"
    t.integer  "steamer_wins"
    t.integer  "steamer_games"
    t.integer  "steamer_gs"
    t.integer  "steamer_ip"
    t.integer  "steamer_er"
    t.integer  "steamer_so"
    t.integer  "steamer_homers"
    t.integer  "steamer_hits"
    t.integer  "throws"
    t.float    "fip"
    t.float    "xfip"
    t.float    "steamer_whip"
    t.float    "era"
    t.string   "fd_alias"
    t.string   "fg_alias"
  end

  add_index "pitchers", ["team_id"], name: "index_pitchers_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.float    "fd_park_factor"
    t.float    "park_factor"
    t.float    "base_runs_per_nine"
    t.float    "runs_per_nine"
    t.integer  "games"
    t.string   "alias"
  end

  create_table "user_lines", force: :cascade do |t|
    t.integer  "matchup_id"
    t.integer  "user_id"
    t.float    "visitor_off"
    t.float    "visitor_def"
    t.float    "home_off"
    t.float    "home_def"
    t.float    "line"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
