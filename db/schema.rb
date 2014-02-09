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

ActiveRecord::Schema.define(version: 20140208012557) do

  create_table "interests", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tweet_id"
    t.integer  "like_count"
  end

  create_table "matches", force: true do |t|
    t.integer  "user1"
    t.integer  "user2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compatability"
  end

  create_table "tweets", force: true do |t|
    t.string   "text"
    t.string   "name"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "twitter_id"
    t.integer  "user_twitter_id"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "twitter_handle"
    t.integer  "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_id"
  end

end
