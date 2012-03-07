class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Mongoid::Paranoia


# ---
# Name


  field :name, type: String
  # TODO Validate name being only [a-Z][0-9]\-
  validates_uniqueness_of :name, scope: :creator_id
  validates_presence_of :name
  slug  :name, index: true, scope: :creator_id

  scope :by_name, ->(name) { where(name: name) }


# ---
# Creator


  belongs_to :creator,
    inverse_of: :created_worlds,
    class_name: 'User'
  validates_presence_of :creator

  def self.find_by_creator_and_slug!(creator, slug)
    where(creator_id: creator.id).find_by_slug!(slug)
  end

  scope :by_creator, ->(user) { where(creator_id: user.id) }

  def creator=(creator)
    write_attribute :creator_id, creator.id
    add_op(creator)
  end


# ---
# Cover Photo


  mount_uploader :photo, CoverPhotoUploader

  def fetch_photo!
    self.remote_photo_url = "http://d14m45jej91i3z.cloudfront.net/#{id}/base.png"
  rescue OpenURI::HTTPError
  end



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
# Members


  embeds_many :memberships, cascade_callbacks: true

  def add_member(user)
    memberships.find_or_initialize_by(user_id: user.id)
  end

  def add_op(user)
    add_member(user).tap {|m| m.op! }
  end

  def member?(user)
    memberships.where(user_id: user.id).exists?
  end

  def op?(user)
    memberships.ops.where(user_id: user.id).exists?
  end

  def ops
    memberships.ops.pluck(:user)
  end

  def members
    memberships.pluck(:user)
  end

  embeds_many :membership_requests, cascade_callbacks: true do
    def include_user?(user)
      where(user_id: user.id).exists?
    end
  end


# ---
# Online Players


  def player_ids
    $redis.smembers("#{redis_key}:connected_players").map {|id| BSON::ObjectId(id)}
  end

  def players
    User.find(player_ids)
  end

  def offline_players
    User.find(memberships.map(&:user_id) - player_ids)
  end

  def broadcast(event_name, data, socket_id=nil)
    pusher_channel.trigger event_name, data, socket_id
  end

  def say(msg)
    send_stdin "say #{msg}"
  end

  def tell(user, msg)
    send_stdin "/tell #{user.username} #{msg}"
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
