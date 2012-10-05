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

ActiveRecord::Schema.define(:version => 20121005002242) do

  create_table "comments", :force => true do |t|
    t.integer  "server_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["server_id"], :name => "index_comments_on_server_id"

  create_table "credit_packs", :force => true do |t|
    t.integer  "cents",      :default => 0, :null => false
    t.integer  "credits",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "funpacks", :force => true do |t|
    t.string  "name"
    t.integer "game_id"
    t.integer "creator_id"
  end

  add_index "funpacks", ["game_id"], :name => "index_funpacks_on_game_id"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "super_servers",   :default => false, :null => false
    t.string   "slug",            :default => ""
    t.boolean  "persistant_data", :default => false, :null => false
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "server_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["server_id"], :name => "index_memberships_on_server_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "players", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "players", ["game_id"], :name => "index_players_on_game_id"
  add_index "players", ["user_id"], :name => "index_players_on_user_id"

  create_table "reward_claims", :force => true do |t|
    t.integer  "reward_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reward_claims", ["reward_id", "user_id"], :name => "index_reward_claims_on_reward_id_and_user_id", :unique => true

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.integer  "credits"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "servers", :force => true do |t|
    t.string   "name",                 :default => ""
    t.integer  "creator_id"
    t.integer  "funpack_id"
    t.integer  "upload_id"
    t.string   "ip"
    t.string   "host"
    t.integer  "port"
    t.text     "settings"
    t.text     "map_markers"
    t.datetime "last_mapped_at"
    t.integer  "minutes_played",       :default => 0
    t.integer  "world_minutes_played", :default => 0
    t.integer  "pageviews",            :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "super_server",         :default => false, :null => false
  end

  add_index "servers", ["host"], :name => "index_servers_on_host", :unique => true
  add_index "servers", ["upload_id"], :name => "index_servers_on_upload_id"

  create_table "users", :force => true do |t|
    t.string   "username",               :default => ""
    t.string   "slug",                   :default => ""
    t.string   "email"
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "facebook_uid"
    t.boolean  "admin",                  :default => false, :null => false
    t.boolean  "unlimited",              :default => false, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "locale"
    t.integer  "timezone",               :default => 0
    t.string   "gender"
    t.integer  "credits",                :default => 0,     :null => false
    t.string   "customer_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "mail_prefs"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
