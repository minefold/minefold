namespace :jobs do
  task :clean_world_backups => :environment do
    CleanWorldBackupsJob.perform
  end
end
