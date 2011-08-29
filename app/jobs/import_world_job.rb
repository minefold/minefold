require 'tmpdir'

# class TarGz
#   attr_reader :options
#
#   def self.new options = {}
#     if RUBY_PLATFORM =~ /darwin/i
#       OSX.new options
#     elsif RUBY_PLATFORM =~ /linux/i
#       Linux.new options
#     else
#       raise "Windows!? WTF!"
#     end
#   end
#
#   class Base
#     attr_reader :options
#     def initialize options = {}
#       @options = { sudo:false }.merge(options)
#     end
#
#     def sudo_cmd
#       ENV['rvm_version'] ? 'rvmsudo' : 'sudo'
#     end
#
#     def sudo cmd
#       `#{sudo_cmd} #{cmd}`
#     end
#
#     def run_command cmd
#       if options[:sudo]
#         sudo cmd
#       else
#         `#{cmd}`
#       end
#     end
#
#     def archive path, output_file, options = {}
#       run_command "tar #{option_string(options)} -czf '#{output_file}' '#{path}'"
#     end
#
#     def extract archive_file, options = {}
#       run_command "tar #{option_string(options)} -xzf '#{archive_file}'"
#     end
#   end
#
#   class OSX < Base
#     def option_string options
#       options.map{|k,v| "--#{k} '#{v}'"}.join(" ")
#     end
#   end
#
#   class Linux < Base
#     def option_string options
#       options.map{|k,v| "--#{k}='#{v}'"}.join(" ")
#     end
#   end
# end

class ImportWorldJob
  @queue = :low

  class InvalidArchive < StandardError; end
  class InvalidWorld < StandardError; end



  def self.perform world_id, filename
    new(World.find(world_id)).process! filename
  end

  def initialize(world)
    @world = world
  end


# private

  def self.storage
    @storage ||= Fog::Storage.new provider: 'AWS',
                         aws_access_key_id: ENV['S3_KEY'],
                     aws_secret_access_key: ENV['S3_SECRET']
  end

  def process!(filename)
    tmp_dir = File.join(Dir.tmpdir, world.id.to_s)

    # begin
      # import_dir = FileUtils.mkdir_p(File.join(tmp_dir, 'import')).last
      # extract_dir = FileUtils.mkdir_p("#{base_path}/extract").last
    Dir.chdir tmp_dir do
      # puts "Downloading #{filename} => #{File.expand_path(filename)}"

        remote_file = Storage.new.worlds_to_import.files.get filename
        File.open(filename, 'w') {|local_file| local_file.write(remote_file.body)}

        puts "Extracting..."
        extract_archive filename
        FileUtils.rm_f filename

        world_path = find_world_path

        FileUtils.mkdir_p "#{import_path}/#{world_id}/#{world_id}"
        FileUtils.cp_r "#{world_path}/.", "#{import_path}/#{world_id}/#{world_id}"

        Dir.chdir import_path do
          archive_filename = "#{world_id}.tar.gz"
          archive_path = File.expand_path archive_filename
          puts "Rearchiving to #{archive_path}"

          TarGz.new.archive world_id, archive_path

          puts "Uploading #{archive_filename}"
          directory = Storage.new.worlds
          directory.files.create(
            :key    => archive_filename,
            :body   => File.open(archive_path),
            :public => false
          )
        end

        update_world_status world_id, ''
      end
    rescue InvalidArchive
      update_world_status world_id, 'invalid_archive'
    rescue InvalidWorld
      update_world_status world_id, 'invalid_world'
    ensure
      FileUtils.rm_rf base_path
      puts "Complete"
    end
  end

  def self.extract_archive filename
    # right now we just assume it's a zip file
    `unzip #{filename}`
    raise InvalidArchive unless $?.success?
  end

  def self.find_world_path
    puts Dir["**/*"].join("\n")
    region_path = Dir["**/*"].find{|dir| dir =~ /region\/r\.0\.0\.mcr/ }
    raise InvalidWorld unless region_path
    puts "Found region data"

    File.expand_path(region_path.gsub("region/r.0.0.mcr", ""))
  end

  def self.update_world_status world_id, status
    connection = MinefoldDb.connection

    worlds = connection['worlds']
    worlds.update({'_id' => BSON::ObjectId(world_id)}, {"$set" => { "status" => status }})
  end
end
