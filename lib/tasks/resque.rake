require 'resque/tasks'

task "resque:setup" => :environment do
  Bundler.require(:worker)

  Resque.after_fork do
    ActiveRecord::Base.establish_connection
  end
end
