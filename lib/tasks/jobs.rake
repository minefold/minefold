namespace :jobs do
  task :clean_world_backups => :environment do
    CleanWorldBackupsJob.perform
  end

  task :subscribe_player => :environment do
    Resque.enqueue SubscribePlayerJob, ENV['USER_ID']
  end

  task :import_world => :environment do
    world_upload = WorldUpload.new(
      s3_key: 'pflurch-4f2cb421578e830001000157-20120205003744Hardcore Straightedge.zip'
    )

    WorldUploadJob.new(world_upload).process!
  end

  task :minute_played => :environment do
    Resque.enqueue MinutePlayedJob, ENV['PLAYER_ID'] || '4f611d4c594e986825f7327c', ENV['WORLD_ID'] || '4f593ad0c3b5a024e8000017', Time.now
  end
end
