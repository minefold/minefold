#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)

require 'rake/clean'

Minefold::Application.load_tasks

require 'resque/tasks'

# Intercom.app_id = "8oc9zbvo"
# Intercom.api_key = "d4080acfd4d6455b05e221cf5900ea9ff0970566"
# 
# count = User.count
# User.all.each_with_index do |u, i|
#   puts "#{i}/#{count} #{u.email}"
#   begin
#     Intercom::User.create({
#       email: u.email, 
#       created_at: u.created_at.to_i,
#       last_seen_ip: u.last_sign_in_ip
#     }.merge(custom_data:u.tracking_data))
#   rescue RestClient::RequestTimeout
#     sleep 1
#     retry
#   end
# end