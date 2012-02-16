require 'tmpdir'
require 'find'
require 'fileutils'
require 'zip/zip'
require 'tar_gz'

class WorldUpload
  include Mongoid::Document
  include Mongoid::Timestamps

  class InvalidUploadError < Exception; end
  class UnreadableUploadError < Exception; end

  IGNORED_FILES = ['server.jar']

  # the original file uploaded
  field :s3_key, type: String
  field :filename, type: String

  # the result of processing into a world data file
  field :process_result, type: String

  # the new world data file ready for use
  # field :world_data_file, type: String

  belongs_to :uploader, class_name: 'User'
  belongs_to :world

  field :seed


  # Copies the uploaded file from S3 to a local tmpdir
  def download!
    remote = self.class.storage.directories
      .create(key: ENV['UPLOADS_BUCKET'])
      .files.get(s3_key)

    File.open(uploaded_archive_path, 'wb') do |f|
      f.write(remote.body)
    end
  end

  # Etracts the Zip
  def extract!
    Zip::ZipFile.foreach(uploaded_archive_path)
      .select {|f| f.file? }
      .each {|f|
        path = File.join(extraction_path, f.name)
        # Creates the file's directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(path))
        f.extract(path)
      }

  rescue => e
    raise UnreadableUploadError.new("Couldn't read the Zip archive")
  end

  # Parses level.dat and pulls out the seed
  def parse_seed!
    data = File.read(level_dat_path)

    self.seed = NBTFile.read(data)[1]['Data']['RandomSeed'].value.to_s
  end

  # Prepares the folder structure and makes a tar.gzip
  def build!
    # Make the worldupload-id folder

    # Make the upload key dir
    # Dir.mkdir_p(x)

    # Remove any ignored files
    IGNORED_FILES.each do |f|
      path = File.join(world_path, f)
      File.unlink(path) if File.exist?(path)
    end

    puts "BUILD_PATH: #{build_path}"

    puts "WORLD_PATH: #{world_path}"
    puts "LEVEL_PATH: #{level_path}"

    FileUtils.mkdir_p(build_path)

    # Rename the world path folder to 'level'
    FileUtils.mv(world_path, level_path)

    # TODO Refactor out archive path
    TarGz.new.archive tmpdir, File.basename(build_path), compiled_archive_path
  end

  # Uploads that tar.gzip back up to S3
  def upload!
    worlds_bucket = self.class.storage.directories.create :key => ENV['WORLDS_BUCKET']
    worlds_bucket.files.create key: world_data_file,
                              body: File.open(compiled_archive_path),
                            public: false
  end


  def upload_key
    [self.class.name.downcase, id].join('-')
  end

  def world_data_file
    "#{upload_key}.tar.gz"
  end

  def pusher_key
    [self.class.name, id].join('-')
  end

  def self.storage
    @storage ||= Fog::Storage.new provider: 'AWS',
                                  aws_access_key_id: ENV['S3_KEY'],
                                  aws_secret_access_key: ENV['S3_SECRET']
  end

  def tmpdir
    @tmpdir ||= Dir.tmpdir
  end

  def uploaded_archive_path
    File.join(tmpdir, s3_key)
  end

  def extraction_path
    File.join(tmpdir, upload_key)
  end

  def build_path
    File.join(tmpdir, "#{upload_key}-build")
  end

  def level_dat_path
    @level_dat_path ||= Find.find(extraction_path) do |path|
      if path =~ /level\.dat$/
        break(path)
      else
        next
      end
    end || raise(InvalidUploadError.new("Couldn't find level.dat in archive"))
  end

  def world_path
     File.dirname(level_dat_path)
  end

  def level_path
    File.join(build_path, 'level')
  end

  def compiled_archive_path
    File.join(tmpdir, world_data_file)
  end

end