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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130128222420) do

  create_table "gps", :force => true do |t|
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "datetime"
    t.integer  "testid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "title",      :default => ""
    t.string   "address",    :default => ""
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "lastvisit",  :default => '2013-01-01 00:00:00'
    t.float    "radius",     :default => 2.0
    t.integer  "sitetype",   :default => 1
    t.string   "bearing",    :default => "N"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "radios", :force => true do |t|
    t.string   "title"
    t.integer  "location_id"
    t.string   "mac"
    t.string   "sn"
    t.string   "ip"
    t.integer  "devtype"
    t.string   "hwver"
    t.string   "swver"
    t.string   "contact"
    t.datetime "last_update"
    t.boolean  "installed"
    t.integer  "airlink_id"
    t.integer  "lanlink_id"
    t.integer  "network_id"
    t.string   "sb_mask"
    t.string   "dgw"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "mytype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tests", :force => true do |t|
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "locations_id"
    t.integer  "actions_id"
    t.datetime "last_run"
    t.datetime "next_run"
    t.integer  "trafic_gen_id"
    t.boolean  "location_based"
    t.boolean  "time_based"
    t.boolean  "auto_start"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
