#!/usr/bin/env rake
require File.expand_path('../config/application', __FILE__)
Minefold::Application.load_tasks

# http://stackoverflow.com/questions/7807733/resque-worker-failing-with-postgresql-server/7846127#7846127
task "resque:setup" => :environment do
  Resque.after_fork do |worker|
    ActiveRecord::Base.establish_connection
  end
end