#!/usr/bin/env ruby
# encoding: utf-8

# {"_id"=>"4e8e61e825e5d700010001e9", "admin"=>false, "authentication_token"=>"h7huM5SKoYHKHYr1Ebpz", "avatar"=>"AlkaiserNova.png", "beta"=>true, "confirmed_at"=>2012-01-29 03:32:22 UTC, "created_at"=>2011-10-07 02:20:24 UTC, "credits"=>14037, "current_sign_in_at"=>2012-04-06 10:33:07 UTC, "current_sign_in_ip"=>"115.64.158.22", "current_world_id"=>"4f06643bc04f940f03000001", "email"=>"alkaisernova@gmail.com", "encrypted_password"=>"$2a$10$mV7atkqzwjOsWqodhnrrUOqfhV8VR9VH5voZHVBpeY1Of8RU80Opa", "host"=>"pluto.minefold.com", "invite_token"=>"11wi61", "last_connected_at"=>2012-01-06 12:50:23 UTC, "last_played_at"=>2012-01-31 02:37:46 UTC, "last_sign_in_at"=>2012-01-12 12:21:28 UTC, "last_sign_in_ip"=>"115.64.158.22", "last_world_started_mail_sent_at"=>2012-07-03 09:52:55 UTC, "minutes_played"=>4091, "mpid"=>"4e8e61e825e5d700010001e9", "notifications"=>{}, "opped_world_ids"=>[], "plan_expires_at"=>2014-02-02 20:21:27 UTC, "referral_code"=>"r6c8vf", "safe_username"=>"alkaisernova", "sign_in_count"=>24, "slug"=>"alkaisernova", "stripe_id"=>"cus_cyup6MzmLynhsv", "unlimited"=>true, "updated_at"=>2012-07-03 09:52:55 UTC, "username"=>"AlkaiserNova", "verification_token"=>"pkkxvm"}


task :import_from_v1 => :environment do
  mongo_session = Mongoid.session(:default)
  users = mongo_session[:users]
  
  total_days_of_pro_left = 0.0
  total_credits_reimbursed = 0
  total_pro_users = 0
  
  users.find.each do |raw|
    
    u = User.new
    
    # Migrate data
    u.admin = raw['admin'] || false
    u.authentication_token = raw['authentication_token']
    u.confirmed_at = raw['confirmed_at']
    u.created_at = raw['created_at']
    u.current_sign_in_at = raw['current_sign_in_at']
    u.current_sign_in_ip = raw['current_sign_in_ip']
    u.email = raw['email']
    u.encrypted_password = raw['encrypted_password']
    u.last_sign_in_at = raw['last_sign_in_at']
    u.last_sign_in_ip = raw['last_sign_in_ip']
    u.sign_in_count = raw['sign_in_count']
    u.username = raw['username']
    u.players.new(game: minecraft, uid: raw['safe_username'])
    u.customer_id = raw['stripe_id']
    u.updated_at = raw['updated_at']
    
    
    # Figure out credits
    if raw['plan_expires_at']
      days_left_of_pro = (raw['plan_expires_at'] - Time.now) / 1.day
      rate = 3 * 60
      cr = (days_left_of_pro * rate).ceil
    
      if raw['plan_expires_at'].future?
        u.credits = cr
        total_days_of_pro_left += days_left_of_pro
        total_credits_reimbursed += cr
        total_pro_users += 1
      end
      
    end
    
  end
  
  puts 'total credits reimbursed', total_credits_reimbursed
  
  
  worlds = mongo_session[:worlds]
  minecraft_players = mongo_session[:minecraft_players]
  
  worlds.fnd.each do |raw|
    s = Server.new
    
    s.partycloud_id = raw['_id']
    s.created_at = raw['created_at']
    s.updated_at = raw['updated_at']
    
    s.last_mapped_at = raw['last_mapped_at']
    
    # creator
    creator = users.find('_id' => raw['creator_id']).first
    s.creator = User.where(username: creator['username']).first
    
    # funpack
    
    s.name = raw['name']
    
    s.settings = {
      'game_mode' => raw['game_mode'],
      'generate_structures' => raw['generate_structures'],
      'level_type' => raw['level_type'],
      'pvp' => raw['pvp'],
      'seed' => raw['seed'],
      'spawn_animals' => raw['spawn_animals'],
      'spawn_monsters' => raw['spawn_monsters'],
      'spawn_npcs' => raw['spawn_npcs']
    }
    
    s.settings['blacklist'] = raw['blacklisted_player_ids'].map do |id|
      minecraft_players.find('_id' => id).first['username']
    end.join("\n")

    s.settings['ops'] = raw['opped_player_ids'].map do |id|
      minecraft_players.find('_id' => id).first['username']
    end.join("\n")
    
    s.settings['whitelist'] = raw['whitelisted_player_ids'].map do |id|
      minecraft_players.find('_id' => id).first['username']
    end.join("\n")
    
  end
  
end
