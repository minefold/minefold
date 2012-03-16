class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia


  attr_accessible :name

# --

  index [
    [:_id, Mongo::ASCENDING],
    [:deleted_at, Mongo::ASCENDING],
    [:creator_id, Mongo::ASCENDING],
    [:slug, Mongo::ASCENDING]
  ], unique: true


# ---
# Name


  def self.sanitize_name(name)
    name.strip.downcase
  end

  field :name, type: String

  validates_format_of :name, with: /^\w+$/
  validates_uniqueness_of :name, scope: :creator_id
  validates_presence_of :name

  field :slug, type: String
  scope :find_by_name, ->(name) {
    find_by(slug: sanitize_name(name))
  }

  def name=(str)
    super(str.strip)
    self.slug = self.class.sanitize_name(str)
  end

  def to_param
    slug.to_param
  end


# ---
# Creator


  def self.find_by_creator_and_slug!(creator, slug)
    where(creator_id: creator.id).find_by_slug!(slug)
  end

  belongs_to :creator,
    inverse_of: :created_worlds,
    class_name: 'User'

  validates_presence_of :creator

  scope :by_creator, ->(user) { where(creator_id: user.id) }


# ---
# Cover Photo


  mount_uploader :photo, CoverPhotoUploader

  def fetch_photo!
    self.remote_photo_url = "http://d14m45jej91i3z.cloudfront.net/#{id}/base.png"
  rescue OpenURI::HTTPError
  end


# ---
# Tags


  embeds_many :tags



# ---
# Cloning


  belongs_to :parent, inverse_of: :children, class_name: 'World'
  has_many :children, inverse_of: :parent, class_name: 'World'

  def clone?
    not parent.nil?
  end

  def clone!
    World.new(
      parent: self,
      name: name,
      # settings: settings,
      # map: map
      seed: seed,
      game_mode: game_mode,
      level_type: level_type,
      difficulty_level: difficulty_level,
      world_data_file: world_data_file,
      map_data: map_data
    )
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

  def players
    opped_players | whitelisted_players
  end

  embeds_many :membership_requests, cascade_callbacks: true do
    def include_user?(user)
      where(user_id: user.id).exists?
    end
  end


# ---
# Online Players


  def connected_player_ids
    $redis.smembers("#{redis_key}:connected_players").map {|id| BSON::ObjectId(id)}
  end

  def connected_players
    User.find(connected_player_ids)
  end

  def offline_players
    User.find(opped_player_ids + whitelisted_player_ids - player_ids)
  end

  def say(msg)
    send_stdin "say #{msg}"
  end

  def tell(player, msg)
    send_stdin "/tell #{player.username} #{msg}"
  end


# ---
# Events


  has_many :events, as: :target,
                 order: [:created_at, :desc]


# ---
# Settings


  GAME_MODES = [:survival, :creative]
  LEVEL_TYPES = ['DEFAULT', 'FLAT']
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :seed, type: String, default: -> { Time.now.to_i.to_s }

  field :game_mode, type: Integer, default: GAME_MODES.index(:survival)
  validates_numericality_of :game_mode,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: GAME_MODES.size

  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  validates_numericality_of :difficulty_level,
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: DIFFICULTIES.size

  field :level_type, type: String, default: LEVEL_TYPES.first
  # validates_inclusion_of :level_type, in: LEVEL_TYPES

  field :pvp, type: Boolean, default: true
  field :spawn_monsters, type: Boolean, default: true
  field :spawn_animals, type: Boolean, default: true


# ---
# Comments

  embeds_many :comments, as: :commentable


# ---
# Stats


  field :minutes_played, type: Integer, default: 0
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
    world_data = $redis.hget "worlds:running", id
    if world_data
      instance_id = JSON.parse(world_data)['instance_id']
      $redis.publish("workers:#{instance_id}:worlds:#{id}:stdin", str)
    end
  end

end
