class WorldMappedJob
  @queue = :low
  
  THUMB_WIDTH = 200
  THUMB_HEIGHT = 100
  
  def self.perform world_id, map_data
    job = new World.find(world_id)
    job.set_map_data map_data
    job.create_thumbnail
  end
  
  attr_reader :world
  
  def initialize world
    @world = world
  end
  
  def set_map_data map_data
    world.set :last_mapped_at, Time.now
    world.set :map_data, map_data
    
    puts "world:#{world.id} mapped at #{world.last_mapped_at}"
  end

  def create_thumbnail
    run "mkdir -p #{File.dirname local_thumb} && curl --silent --show-error #{remote_base} | convert -gravity center -crop #{THUMB_WIDTH}x#{THUMB_HEIGHT}+0+0 - #{local_thumb}"
    
    directory = storage.directories.create :key => ENV['MAPS_BUCKET']
    directory.files.create key: File.join(world.id.to_s, 'thumb.png'),
                          body: File.open(local_thumb),
                        public: true
                        
    puts "world:#{world.id} thumbnail generated"
  end
  
  def local_thumb
    Rails.root.join 'tmp', 'world_thumbs', world.id.to_s, 'thumb.png'
  end
    
  def remote_base
    File.join "http:#{world.map_assets_url}", 'base.png'
  end
  
  def run cmd
    puts cmd, `#{cmd}`
  end
  
  def storage
    @storage ||= Fog::Storage.new provider: 'AWS',
                         aws_access_key_id: ENV['S3_KEY'],
                     aws_secret_access_key: ENV['S3_SECRET']
  end
  
end