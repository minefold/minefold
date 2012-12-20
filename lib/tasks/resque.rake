require 'resque/tasks'
require 'resque_scheduler/tasks'

task "resque:setup" => :environment do
  Bundler.require(:worker)

  Resque.after_fork do |worker|
    ActiveRecord::Base.establish_connection
  end
end
