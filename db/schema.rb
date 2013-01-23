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

ActiveRecord::Schema.define(:version => 20130121213406) do

  create_table "accounts", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accounts", ["type"], :name => "index_players_on_game_id"
  add_index "accounts", ["user_id"], :name => "index_players_on_user_id"

  create_table "activities", :force => true do |t|
    t.string   "type",         :null => false
    t.integer  "actor_id"
    t.string   "actor_type"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "bonuses", :force => true do |t|
    t.string   "type",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.integer  "coins"
  end

  add_index "bonuses", ["type", "user_id"], :name => "index_bonus_claims_on_bonus_type_and_user_id"
  add_index "bonuses", ["type"], :name => "index_bonus_claims_on_bonus_type"

  create_table "coin_packs", :force => true do |t|
    t.integer  "cents",      :default => 0, :null => false
    t.integer  "coins",      :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "funpacks", :force => true do |t|
    t.string  "name"
    t.integer "game_id"
    t.integer "creator_id"
    t.string  "party_cloud_id"
    t.text    "description"
    t.string  "info_url"
    t.boolean "imports",         :default => false
    t.string  "slug",            :default => ""
    t.text    "settings_schema"
  end

  add_index "funpacks", ["game_id"], :name => "index_funpacks_on_game_id"
  add_index "funpacks", ["party_cloud_id"], :name => "index_funpacks_on_party_cloud_id", :unique => true
  add_index "funpacks", ["slug"], :name => "index_funpacks_on_slug", :unique => true

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "slug",               :default => ""
    t.string   "party_cloud_id"
    t.boolean  "auth",               :default => false, :null => false
    t.boolean  "routing",            :default => false, :null => false
    t.boolean  "maps",               :default => false, :null => false
    t.integer  "default_funpack_id"
  end

  add_index "games", ["party_cloud_id"], :name => "index_games_on_party_cloud_id", :unique => true

  create_table "gifts", :force => true do |t|
    t.integer  "coin_pack_id"
    t.string   "token",        :limit => 12
    t.integer  "parent_id"
    t.integer  "child_id"
    t.string   "customer_id"
    t.string   "charge_id"
    t.string   "name"
    t.string   "email"
    t.string   "to"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "gifts", ["child_id"], :name => "index_gifts_on_child_id"
  add_index "gifts", ["coin_pack_id"], :name => "index_gifts_on_coin_pack_id"
  add_index "gifts", ["parent_id"], :name => "index_gifts_on_parent_id"
  add_index "gifts", ["token"], :name => "index_gifts_on_token"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "server_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["server_id"], :name => "index_memberships_on_server_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "player_sessions", :force => true do |t|
    t.integer  "server_session_id"
    t.integer  "account_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "server_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["author_id"], :name => "index_comments_on_author_id"
  add_index "posts", ["server_id"], :name => "index_comments_on_server_id"

  create_table "server_sessions", :force => true do |t|
    t.integer  "server_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "server_sessions", ["server_id"], :name => "index_sessions_on_server_id"

  create_table "servers", :force => true do |t|
    t.string   "name",                 :default => ""
    t.integer  "creator_id"
    t.integer  "funpack_id"
    t.string   "host"
    t.integer  "port"
    t.text     "settings"
    t.integer  "minutes_played",       :default => 0
    t.integer  "world_minutes_played", :default => 0
    t.integer  "pageviews",            :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "shared",               :default => false, :null => false
    t.string   "party_cloud_id"
    t.datetime "deleted_at"
    t.float    "score",                :default => 0.0
    t.text     "description"
    t.integer  "state"
  end

  add_index "servers", ["deleted_at", "creator_id"], :name => "index_servers_on_deleted_at_and_creator_id"
  add_index "servers", ["deleted_at", "host", "port"], :name => "index_servers_on_deleted_at_and_host_and_port"
  add_index "servers", ["party_cloud_id"], :name => "index_servers_on_party_cloud_id", :unique => true

  create_table "stars", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "server_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                             :default => ""
    t.string   "slug",                                 :default => ""
    t.string   "email"
    t.string   "encrypted_password",                   :default => "",    :null => false
    t.boolean  "admin",                                :default => false, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "locale"
    t.integer  "timezone",                             :default => 0
    t.string   "gender"
    t.integer  "coins",                                :default => 0,     :null => false
    t.string   "customer_id"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.text     "notifications"
    t.string   "avatar"
    t.string   "name",                                 :default => ""
    t.string   "distinct_id"
    t.string   "legacy_id"
    t.datetime "deleted_at"
    t.string   "invitation_token",       :limit => 12
    t.integer  "invited_by_id"
    t.string   "verification_token",     :limit => 12
    t.boolean  "beta",                                 :default => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["deleted_at", "invitation_token"], :name => "index_users_on_deleted_at_and_invitation_token", :unique => true
  add_index "users", ["deleted_at", "verification_token"], :name => "index_users_on_deleted_at_and_verification_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "server_id"
    t.integer  "user_id"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "watchers", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "server_id"
  end

  create_table "worlds", :force => true do |t|
    t.integer  "server_id"
    t.string   "party_cloud_id"
    t.string   "legacy_url"
    t.datetime "last_mapped_at"
    t.text     "map_data"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "legacy_parent_id"
    t.datetime "map_queued_at"
  end

  add_index "worlds", ["party_cloud_id"], :name => "index_worlds_on_party_cloud_id", :unique => true
  add_index "worlds", ["server_id"], :name => "index_worlds_on_server_id"

end
