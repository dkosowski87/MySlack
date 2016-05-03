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

ActiveRecord::Schema.define(version: 20160503150914) do

  create_table "channels", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "team_id",  limit: 4
    t.integer "admin_id", limit: 4
  end

  add_index "channels", ["admin_id"], name: "index_channels_on_admin_id", using: :btree
  add_index "channels", ["team_id"], name: "index_channels_on_team_id", using: :btree

  create_table "channels_users", id: false, force: :cascade do |t|
    t.integer "channel_id", limit: 4, null: false
    t.integer "user_id",    limit: 4, null: false
  end

  add_index "channels_users", ["channel_id", "user_id"], name: "index_channels_users_on_channel_id_and_user_id", using: :btree
  add_index "channels_users", ["user_id", "channel_id"], name: "index_channels_users_on_user_id_and_channel_id", using: :btree

  create_table "msgs", force: :cascade do |t|
    t.text     "content",        limit: 65535
    t.integer  "sender_id",      limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.string   "type",           limit: 255
    t.string   "state",          limit: 255
  end

  add_index "msgs", ["recipient_type", "recipient_id"], name: "index_msgs_on_recipient_type_and_recipient_id", using: :btree
  add_index "msgs", ["sender_id"], name: "index_msgs_on_sender_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "number_of_members", limit: 4
    t.string   "password_digest",   limit: 255
  end

  add_index "teams", ["password_digest"], name: "index_teams_on_password_digest", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "team_id",              limit: 4
    t.string   "state",                limit: 255
    t.string   "password_digest",      limit: 255
    t.string   "email",                limit: 255
    t.string   "password_reset_token", limit: 255
    t.string   "type",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

end
