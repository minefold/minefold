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

  task :map_unmapped_worlds => :environment do
    World.where(:last_mapped_at => nil, :minutes_played.gt => 0).each {|w| Resque.push 'maps_high', class: 'Job::MapWorld', args: [w.id.to_s]}
  end
end
