require 'set'

class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  store_in collection: 'worlds'


  # TODO: manage these settings with funpacks

  attr_accessible :name,
    :world_upload_id,
    :funpack,
    :seed,
    :game_mode,
    :difficulty,
    :level_type,
    :pvp,
    :spawn_monsters,
    :spawn_animals,
    :generate_structures,
    :spawn_npcs,
    :minecraft_version

# --

  index(
    {_id: 1, deleted_at: 1, creator_id: 1, slug: 1},
    {unique: true}
  )


# ---
# Name


  def self.sanitize_name(name)
    name.strip.downcase.gsub(/[^\w]+/, '_').gsub(/^_+/, '').gsub(/_+$/, '')
  end

  def self.find_by_name(name)
    find_by(slug: sanitize_name(name))
  end

  field :name, type: String

  validates_uniqueness_of :name, scope: :creator_id
  validates_presence_of :name

  def name=(str)
    super(str.strip)
    self.slug = self.class.sanitize_name(str)[0...SLUG_LENGTH]
  end

  SLUG_LENGTH = 20

  field :slug, type: String
  validates_uniqueness_of :slug, scope: :creator_id
  validates_presence_of :slug
  validates_length_of :slug, within: (1..SLUG_LENGTH), on: :create
  validates_format_of :slug, with: /^[a-z0-9_]+$/

  def name_with_creator
    "#{creator.username}/#{name}"
  end

  def to_param
    slug.to_param
  end


# ---
# Creator


  belongs_to :creator,
    inverse_of: :created_worlds,
    class_name: 'User'

  validates_presence_of :creator

  scope :by_creator, ->(user) { where(creator_id: user.id) }

  def fullname
    [creator.username, slug].join('/')
  end



# ---
# Cover Photo


  mount_uploader :cover_photo, CoverPhotoUploader do
    def store_dir
      File.join('world', mounted_as.to_s, model.id.to_s)
    end
  end

  def fetch_cover_photo!
    self.remote_cover_photo_url = "http://d14m45jej91i3z.cloudfront.net/#{id}/base.png"
  rescue OpenURI::HTTPError
  end


# ---
# Tags


  # embeds_many :tags



# ---
# Cloning


  belongs_to :parent, inverse_of: :children, class_name: 'World'
  has_many :children, inverse_of: :parent, class_name: 'World'

  def clone?
    not parent.nil?
  end

  field :funpack, default: 'minecraft-vanilla'

  # TODO: these should go into a settings hash

  field :minecraft_version, default: 'HEAD'
  field :new_player_can_build, default: 'true'

  WORLD_SETTINGS = %w(
    game_mode
    level_type
    seed
    difficulty
    pvp
    spawn_monsters
    spawn_animals
    generate_structures
    spawn_npcs )


  def clone!
    data = {
      name: self.class.sanitize_name(name),
      funpack: funpack,
      world_data_file: world_data_file,
      map_data: map_data
    }

    settings = WORLD_SETTINGS.each_with_object({}) do |setting, h|
      h[setting.to_sym] = self.send(setting.to_sym)
    end

    world = World.new(data.merge(settings))
    world.parent = self
    world
  end


# ---
# Data


  # Legacy backup file in S3, can be blank
  field :world_data_file, type: String
  belongs_to :world_upload

  def upload_filename_prefix
    [creator.safe_username, creator.id, Time.now.strftime('%Y%m%d%H%M%S'), nil].join('-')
  end


# ---
# Maps


  field :last_mapped_at, type: DateTime
  field :map_data, type: Hash

  # Does a map exist *at all*
  def map?
    mapped? or (clone? and parent.map?)
  end

  # Has the world been mapped personally
  def mapped?
    not last_mapped_at.nil?
  end

  # The base location of the map data
  def map_assets_url
    case
    when mapped?
      File.join ENV['WORLD_MAPS_URL'], id.to_s
    when clone?
      parent.map_assets_url
    end
  end


# ---
# Players


  has_and_belongs_to_many :opped_players,
    class_name: 'MinecraftPlayer',
    inverse_of: nil

  has_and_belongs_to_many :whitelisted_players,
    class_name: 'MinecraftPlayer',
    inverse_of: nil

  has_and_belongs_to_many :blacklisted_players,
    class_name: 'MinecraftPlayer',
    inverse_of: nil

  def player_ids
    (opped_player_ids | whitelisted_player_ids) - blacklisted_player_ids
  end

  def players
    # MinecraftPlayer.find(player_ids)

    # TODO: this is a hack while I figure out why some player_ids don't exist
    MinecraftPlayer.includes(:user).in(_id: player_ids)
  end

  embeds_many :membership_requests, cascade_callbacks: true do
    def include_user?(user)
      any_of({user_id: user.id}, {minecraft_player_id: user.minecraft_player.id}).exists?
    end
  end

  # ops
  def player_opped? player
    opped_player_ids.include? player.id
  end

  def op_player! player
    add_to_set :opped_player_ids, player.id
  end

  def deop_player! player
    pull :opped_player_ids, player.id unless player == creator.minecraft_player
  end

  # whitelist
  def player_whitelisted? player
    whitelisted_player_ids.include? player.id
  end

  def whitelist_player! player
    if whitelisted_player_ids.include? player.id
      false
    else
      request = membership_requests.where(minecraft_player_id:player.id).first
      request.destroy if request
      add_to_set :whitelisted_player_ids, player.id
    end
  end

  def unwhitelist_player! player
    pull :whitelisted_player_ids, player.id
  end

  # blacklist
  def player_blacklisted? player
    blacklisted_player_ids.include? player.id
  end

  def blacklist_player! player
    add_to_set :blacklisted_player_ids, player.id
  end

  def pardon_player! player
    pull :blacklisted_player_ids, player.id
  end

  def player_count_without_creator
    player_ids.size - 1
  end

# ---
# Online Players

  def online_player_ids
    $redis.hgetall("players:playing").select {|player_id, world_id|
      world_id == id.to_s
    }.keys.map{|player_id| BSON::ObjectId(player_id) }
  end

  def online_players
    MinecraftPlayer.in(_id: online_player_ids)
  end

  def offline_player_ids
    player_ids - online_player_ids
  end

  def offline_players
    MinecraftPlayer.in(_id: offline_player_ids)
  end

  def say(msg)
    send_stdin "say #{msg}"
  end

  def tell(player, msg)
    send_stdin "tell #{player.username} #{msg}"
  end


# ---
# Events


  has_many :events, as: :target,
                 order: [:created_at, :desc]


# ---
# Settings

  def host
    "#{slug}.#{creator.slug}.minefold.com"
  end

  GAME_MODES = [:survival, :creative]
  LEVEL_TYPES = ['DEFAULT', 'FLAT', 'LARGEBIOMES']
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :seed, type: String, default: -> { Time.now.to_i.to_s }

  field :game_mode, type: Integer, default: GAME_MODES.index(:survival)
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: GAME_MODES.size

  field :difficulty, type: Integer, default: DIFFICULTIES.index(:easy)
  validates_numericality_of :difficulty,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: DIFFICULTIES.size

  field :level_type, type: String, default: LEVEL_TYPES.first
  # validates_inclusion_of :level_type, in: LEVEL_TYPES

  field :pvp, type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals, type: Boolean, default: true
  field :generate_structures, type: Boolean, default: true
  field :spawn_npcs, type: Boolean, default: true


# ---
# Comments

  embeds_many :comments, as: :commentable


# ---
# Tags


  def tags
    @tags ||= Set.new.tap do |s|
      s.add Tag.new(GAME_MODES[game_mode].to_s)
      s.add Tag.new(DIFFICULTIES[difficulty].to_s)

      s.add(Tag.new(level_type)) if level_type == 'flat'

      s.add(Tag.new('pvp')) if pvp?
      s.add(Tag.new('monsters')) if spawn_monsters?
      s.add(Tag.new('animals')) if spawn_animals?
      s.add(Tag.new('structures')) if generate_structures?
      s.add(Tag.new('npcs')) if generate_structures?
    end
  end


# ---
# Stats


  field :minutes_played, type: Integer, default: 0
  field :world_minutes_played, type: Integer, default: 0

  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0
  field :last_played_at, type: DateTime

  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0


# ---


  def pusher_key
    "#{collection.name.downcase}-#{id}"
  end

  def redis_key
    "#{collection.name.downcase}:#{id}"
  end


private

  def pusher_channel
    Pusher[pusher_key]
  end

  def send_stdin(str)
    world_data = $redis.hget "worlds:running", id.to_s
    if world_data
      instance_id = JSON.parse(world_data)['instance_id']
      $redis.publish("workers:#{instance_id}:worlds:#{id}:stdin", str)
    end
  end

end
