# encoding: utf-8

require 'zip/zip'
require 'tar_gz'
require 'fileutils'

class ImportWorldJob
  @queue = :low

  def self.perform(world_upload_id)
    new.process WorldUpload.find(world_upload_id)
  end

  def process(world_upload)
    pusher_key = "#{world_upload.class.name}-#{world_upload.id}"
    pusher = Pusher[pusher_key]

    puts "connecting to channel: #{pusher_key}"

    error = nil
    world_data_file = nil
    begin
      world_data_file = process_world_upload world_upload
      error = world_upload.process_result
    rescue => e
      Airbrake.notify(e)
      error = e.to_s
    end

    if error
      puts "Job failed. #{error}"
      pusher.trigger 'error', error
    else
      world_upload.world_data_file = world_data_file
      world_upload.save!
      
      # world = world_upload.world
      # Resque.push 'worlds_to_map', class: 'MapWorld', args: [world.id]

      pusher.trigger 'success', world_upload: { id: world_upload.id }
      puts "Work complete."
    end
  end

  def process_world_upload world_upload
    FileUtils.mkdir_p tmp_dir
    uploaded_world_archive = download_world_upload world_upload.s3_key

    result = validate_world_archive uploaded_world_archive
    if result[:error]
      world_upload.process_result = result[:error]
      world_upload.save
    else
      world_data_file = "upload-#{world_upload.id}"
      world_archive = create_world_archive world_data_file, uploaded_world_archive, result[:world_path]
    
      upload_world_archive world_archive
      "#{world_data_file}.tar.gz"
    end
  end

  def download_world_upload s3_key
    local_filename = "#{tmp_dir}/#{s3_key}"
    puts "Downloading #{s3_key} => #{local_filename}"

    worlds_to_import = storage.directories.create :key => ENV['UPLOADS_BUCKET']
    
    remote_file = worlds_to_import.files.get(s3_key)
    
    File.open(local_filename, 'wb') {|local_file| local_file.write remote_file.body }
    puts "Download finished"

    local_filename
  end

  def upload_world_archive world_archive
    world_archive_name = File.basename world_archive
    puts "Uploading #{world_archive} => #{world_archive_name}"
    
    directory = storage.directories.create :key => ENV['WORLDS_BUCKET']
    directory.files.create key:world_archive_name,
                          body:File.open(world_archive),
                        public:false
    puts "Upload finished"
  end

  def validate_world_archive uploaded_world_archive
    begin
      leveldat_file = Zip::ZipFile.foreach(uploaded_world_archive).find {|zf| zf.name =~ /level\.dat$/ }
      if leveldat_file
        { world_path: File.dirname(leveldat_file.name) }
      else
        { error: 'level.dat file not present in archive' }
      end
    rescue => e
      { error: e.to_s }
    end
  end

  def create_world_archive world_file, world_upload_archive, archive_world_path
    extract_path = "#{tmp_dir}/#{world_file}/extract"
    import_base_path  = "#{tmp_dir}/#{world_file}/import"
    world_data_dir = "#{import_base_path}/#{world_file}"
    level_files = File.join(world_data_dir, "level")
    
    extract_archive world_upload_archive, extract_path

    FileUtils.mkdir_p level_files
    FileUtils.cp_r "#{extract_path}/#{archive_world_path}/.", level_files

    TarGz.new.archive world_data_dir, ".", "#{import_base_path}/#{world_file}.tar.gz", exclude:'server.jar'
    "#{import_base_path}/#{world_file}.tar.gz"
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
    Rails.root.join('tmp', 'world_uploads')
  end
end
