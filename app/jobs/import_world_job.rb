# encoding: utf-8

require 'zip/zip'
require 'tar_gz'
require 'fileutils'

class ImportWorldJob
  @queue = :low
  
  class << self
    
    def perform world_upload_id
      pusher_key = "#{name}-#{world_upload_id}"
      pusher = Pusher[pusher_key]

      error = nil
      begin
        world_upload = process_world_upload WorldUpload.find(world_upload_id)
        error = world_upload.process_result
      rescue => e
        error = e.to_s
      end
      
      if error
        puts "Job failed. #{error}"
        pusher.trigger 'fail', error:error
      else
        puts "Work complete."

        world = world_upload.world
        pusher.trigger 'success', world_upload:{
          filename: world_upload.filename,
            s3_key: world_upload.s3_key,
        }, world: {
           '_id' => "#{world.id}",
           name: world.name,
           slug: world.slug
        }
      end
    end
  
    def process_world_upload world_upload
      FileUtils.mkdir_p tmp_dir
      world_upload_archive = download_world_upload world_upload.s3_key
    
      result = validate_world_archive world_upload_archive
      if result[:error]
        world_upload.process_result = result[:error]
        world_upload.save
      else
        world_name = File.basename world_upload.filename, ".*"
        puts "Creating world:#{world_name} creator:#{world_upload.uploader.username}"
        
        world = World.create name:world_name, creator:world_upload.uploader
        world_archive = create_world_archive world.id, world_upload_archive, result[:world_path]

        upload_world_archive world_archive, world.id
        world_upload.world = world
        world_upload.save
      end
      world_upload
    end
    
    def download_world_upload s3_key
      local_filename = "#{tmp_dir}/#{s3_key}"
      puts "Downloading #{s3_key} => #{local_filename}"
    
      worlds_to_import = storage.directories.create :key => "minefold.#{Rails.env}.worlds-to-import"
      remote_file = worlds_to_import.files.get s3_key
      File.open(local_filename, 'wb') {|local_file| local_file.write remote_file.body }
      puts "Download finished"
      
      local_filename
    end
    
    def upload_world_archive world_archive, world_id
      puts "Uploading #{world_archive}"
      directory = storage.directories.create :key => "minefold.#{Rails.env}.worlds"
      directory.files.create key:"#{world_id}.tar.gz",
                            body:File.open(world_archive),
                          public:false
      puts "Upload finished"
    end
    
    def validate_world_archive world_upload_archive
      begin
        leveldat_file = Zip::ZipFile.foreach(world_upload_archive).find {|zf| zf.name =~ /level\.dat$/ }
        if leveldat_file
          { world_path: File.dirname(leveldat_file.name) }
        else
          { error: 'level.dat file not present in archive' }
        end
      rescue => e
        { error: e.to_s }
      end
    end
    
    def create_world_archive world_id, world_upload_archive, archive_world_path
      extract_path = "#{tmp_dir}/#{world_id}/extract"
      
      extract_archive world_upload_archive, extract_path
      
      import_path = "#{tmp_dir}/#{world_id}/import/#{world_id}/#{world_id}"
      FileUtils.mkdir_p import_path
      FileUtils.cp_r "#{extract_path}/#{archive_world_path}/.", import_path
      
      Dir.chdir "#{tmp_dir}/#{world_id}/import" do
        TarGz.new.archive world_id, "#{world_id}.tar.gz", exclude:'server.jar'
      end
      "#{tmp_dir}/#{world_id}/import/#{world_id}.tar.gz"
    end

    private

    def storage
      @storage ||= Fog::Storage.new provider: 'AWS',
                           aws_access_key_id: ENV['S3_KEY'],
                       aws_secret_access_key: ENV['S3_SECRET']
    end
    
    def extract_archive archive, destination
      Zip::ZipFile.foreach(archive).select{|zf| zf.file? }.each do |zf|
        FileUtils.mkdir_p File.dirname("#{destination}/#{zf.name}")
        zf.extract "#{destination}/#{zf.name}"
      end
    end
        
    def tmp_dir
      File.join Rails.root, "tmp", "world_uploads"
    end
  end
end
