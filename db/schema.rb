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

ActiveRecord::Schema.define(version: 20160321205552) do

  create_table "kheer_chia_models", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "description",    limit: 255
    t.string   "comment",        limit: 255
    t.integer  "major_id",       limit: 4
    t.integer  "minor_id",       limit: 4
    t.text     "detectable_ids", limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "mini_id",        limit: 4
  end

  create_table "kheer_detectables", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "pretty_name", limit: 255
    t.string   "description", limit: 255
    t.string   "ztype",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "setting_machines", force: :cascade do |t|
    t.string   "ztype",      limit: 255
    t.string   "zstate",     limit: 255
    t.string   "zcloud",     limit: 255
    t.string   "zdetails",   limit: 255
    t.string   "hostname",   limit: 255
    t.string   "ip",         limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "authentication_token",   limit: 255
    t.string   "zrole",                  limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_captures", force: :cascade do |t|
    t.integer  "stream_id",            limit: 4
    t.integer  "storage_machine_id",   limit: 4
    t.integer  "capture_machine_id",   limit: 4
    t.string   "capture_url",          limit: 255
    t.text     "comment",              limit: 65535
    t.integer  "width",                limit: 4
    t.integer  "height",               limit: 4
    t.float    "playback_frame_rate",  limit: 24
    t.integer  "started_by",           limit: 4
    t.integer  "stopped_by",           limit: 4
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.float    "detection_frame_rate", limit: 24
    t.string   "name",                 limit: 255
  end

  add_index "video_captures", ["capture_machine_id"], name: "index_video_captures_on_capture_machine_id", using: :btree
  add_index "video_captures", ["storage_machine_id"], name: "index_video_captures_on_storage_machine_id", using: :btree
  add_index "video_captures", ["stream_id"], name: "index_video_captures_on_stream_id", using: :btree

  create_table "video_clips", force: :cascade do |t|
    t.integer  "capture_id",         limit: 4
    t.string   "zstate",             limit: 255
    t.integer  "length",             limit: 4
    t.integer  "frame_number_start", limit: 4
    t.integer  "frame_number_end",   limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "video_clips", ["capture_id"], name: "index_video_clips_on_capture_id", using: :btree

  create_table "video_streams", force: :cascade do |t|
    t.string   "ztype",      limit: 255
    t.string   "zstate",     limit: 255
    t.string   "zpriority",  limit: 255
    t.string   "name",       limit: 255
    t.string   "base_url",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
