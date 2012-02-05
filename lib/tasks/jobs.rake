namespace :jobs do
  task :clean_world_backups => :environment do
    CleanWorldBackupsJob.perform
  end
  
  task :subscribe_player => :environment do
    Resque.enqueue SubscribePlayerJob, ENV['USER_ID']
  end
  
  task :import_world => :environment do
    ImportWorldJob.new.process WorldUpload.new(
      s3_key: 'pflurch-4f2cb421578e830001000157-20120205003744Hardcore Straightedge.zip'
    )
  end
end
