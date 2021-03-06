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

ActiveRecord::Schema.define(version: 20141127005756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actives", force: true do |t|
    t.integer  "user_id"
    t.integer  "channel_id"
    t.datetime "updated"
  end

  create_table "channels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.string   "network"
    t.string   "api_id"
    t.datetime "last_message"
  end

  add_index "channels", ["api_id"], name: "index_channels_on_api_id", unique: true, using: :btree

  create_table "favorites", force: true do |t|
    t.integer "user_id"
    t.integer "channel_id"
  end

  create_table "messages", force: true do |t|
    t.string   "body"
    t.datetime "creation_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "channel_id"
    t.integer  "topic_id"
  end

  create_table "topics", force: true do |t|
    t.string  "name"
    t.integer "channel_id"
  end

  create_table "user_channels", force: true do |t|
    t.datetime "timeout"
    t.integer  "user_id"
    t.integer  "channel_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
