require 'tar_gz'
require 'tmpdir'

class MapWorld
  class Error < StandardError; end
  # extend Resque::Plugins::Lock
  # include Resque::Plugins::UniqueJob

  @queue = :maps

  attr_accessor :world

  # No pun intended
  # TODO: This seems like it should be somewhere else.
  def self.storage
    Fog::Storage.new(if Rails.env.development?
      {
        provider:   :local,
        local_root: Rails.root.join('public', 's3')
      }
    else
      {
        provider: 'AWS',
        aws_access_key_id: ENV['S3_KEY'],
        aws_secret_access_key: ENV['S3_SECRET'],
        region: 'us-east-1'
      }
    end)
  end

  def self.run_command cmd
    puts "#{cmd}"
    result = `#{cmd}`
    puts result
    result
  end

  def map!
    # Dir.chdir File.dirname(File.expand_path(MAPPER)) do
    #   result = nil
    #
    #   last_map_run = remote_tiles.files.get("#{world_id}/last_map_run")
    #   if last_map_run
    #     puts "incremental map generation"
    #     last_run_path = "#{tile_path}/last_map_run"
    #
    #     download last_run_path, last_map_run
    #     download "#{tile_path}/pigmap.params", storage.world_tiles.files.get("#{world_id}/pigmap.params")
    #     run_command "touch -t $(cat #{last_run_path}) #{last_run_path} && find #{world_data_path} -newer #{last_run_path} > #{world_data_path}/map_changes"
    #     result = run_command "#{MAPPER} -h 1 -r #{world_data_path}/map_changes  -i #{world_data_path} -o #{tile_path}"
    #   else
    #     puts "full map generation"
    #     result = run_command "#{MAPPER} -h 1 -B 4 -T 4 -i #{world_data_path} -o #{tile_path}"
    #   end
    #
    #   raise Errro, result unless $?.success?
    # end

    # create a file with the latest modification date of the world
    # last_modified_time = Dir['**/*'].select{|f| File.file? f }.map{|f| File.mtime f }.sort.last
    # puts "last map modification:#{last_modified_time.strftime('%Y-%m-%d %H:%M.%S')}"
    # run_command "echo '#{last_modified_time.strftime("%Y%m%d%H%M.%S")}' > #{tile_path}/last_map_run"
  end

  def self.perform world_id
    new(World.find(world_id)).process!
  end

  def initialize(world)
    @world = world
  end

  def process!
    log "mapping world:#{world.id} in #{root}"

    Dir.chdir root do
      log "downloading world"
      download remote_worlds.files.get(archive), local_archive

      log "extracting world"
      TarGz.new.extract(local_archive)

      log "downloading tiles"
      download
      # Download existing map tiles

      log "mapping"
      map!

      log "uploading tiles"
      upload_tiles!
      # Upload new map tiles

      world.last_mapped_at = Time.now.utc
      world.save
    end

    log "done mapping world:#{world.id}"
  end

  def upload_tiles!
    Dir.chdir(tiles) do
      Dir['**/*']
        .reject {|f| File.directory?(f)}
        .each do |file|
          remote_path = File.join(world.id.to_s, file)
          remote_tiles.files.create key:remote_path,
                                   body:File.open(file),
                                 public:true
        end
    end
  end

  def download(remote, local_path)
    File.open(local_path, 'w') {|f| f.write(remote.body)}
  end

  def root
    @root ||= File.join(Dir.tmpdir, @world.id.to_s).tap do |path|
      FileUtils.mkdir_p path
    end
  end

  def archive
    "#{@world.id}.tar.gz"
  end

  def local_archive
    File.join(root, archive)
  end

  def tiles
    File.join(root, 'tiles').tap do |path|
      FileUtils.rm_rf(path)
      FileUtils.mkdir_p(path)
    end
  end

  def world_data
    File.join(root, world.id.to_s, world.id.to_s)
  end

  def remote_worlds
    @remote_worlds ||= self.class.storage.directories.create key: "minefold.#{Rails.env}.worlds",
                                                           public: false
  end

  def remote_tiles
    @remote_tiles ||= self.class.storage.directories.create key: "minefold.#{Rails.env}.worlds.tiles",
                                              public: true
  end

  def log(str)
    $stderr.puts(str)
  end

end







