class World
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  GAME_MODES = [:survival, :creative]
  LEVEL_TYPES = %W(DEFAULT FLAT)
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :name, type: String
  validates_uniqueness_of :name, scope: :parent_id
  validates_presence_of :name
  slug  :name, index: true, scope: :parent

  scope :by_name, ->(name) {
    where(name: name)
  }

  field :seed,             type: String, default: ''
  field :game_mode,        type: Integer, default: GAME_MODES.index(:survival)
  field :level_type,       type: String,  default: LEVEL_TYPES.first
  field :difficulty_level, type: Integer, default: DIFFICULTIES.index(:easy)
  field :pvp,              type: Boolean, default: true
  field :spawn_monsters,   type: Boolean, default: true
  field :spawn_animals,    type: Boolean, default: true


  field :last_mapped_at, type: DateTime
  field :minutes_played, type: Integer, default: 0

  field :world_data_file, type: String, default: -> {"#{id}.tar.gz"}  # this is the world backup file in S3, can be blank

  belongs_to :creator, inverse_of: :created_worlds, class_name: 'User'
  belongs_to :world_upload

  belongs_to :creator,
    inverse_of: :created_worlds,
    class_name: 'User'
  validates_presence_of :creator

  def self.find_by_creator_and_slug!(creator, slug)
    where(creator_id: creator.id).find_by_slug!(slug)
  end

  scope :by_creator, ->(user) {
    where(creator_id: user.id)
  }

  belongs_to :parent, inverse_of: :children, class_name: 'World'
  has_many :children, inverse_of: :parent, class_name: 'World'

  # Data

  # this is the world backup file in S3, can be blank
  field :filename, type: String, default: -> {"#{id}.tar.gz"}
  belongs_to :world_upload

  def world_upload=(upload)
    write_attribute :world_upload_id, upload.id
    self.filename = upload.world_data_file
    upload
  end
  
  # map data
  field :last_mapped_at, type: DateTime
  field :map_data, type: Hash

  # Peeps

  embeds_many :memberships

  embeds_many :membership_requests do
    def include_user?(user)
      where(user_id: user.id).exists?
    end
  end

  has_many :events, as: :target,
                    order: [:created_at, :desc]

  field :last_mapped_at, type: DateTime

  field :minutes_played, type: Integer, default: 0


  # Game settings

  GAME_MODES = [:survival, :creative]
  DIFFICULTIES = [:peaceful, :easy, :normal, :hard]

  field :seed, type: String, default: ''

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

  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0

# Finders

  def self.find_by_slug! creator_id, world_slug
    world = World.where(creator_id: creator_id, slug: world_slug).first
    raise Mongoid::Errors::DocumentNotFound.new(World.class, world_slug) unless world
    world
  end

# Callbacks

  after_create do
    memberships.create role: 'op', user: creator
  end

  after_create do
    # if world is being created from an upload, use the uploaded world data file as our starting point
    if world_upload
      self.world_data_file = world_upload.world_data_file
      save!
    end
  end


  # Stats

  field :pageviews, type: Integer, default: 0
  validates_numericality_of :pageviews,
    only_integer: true,
    greater_than_or_equal_to: 0


# Settings

  GAME_MODES.each do |mode|
    define_method("#{mode}?") do
      GAME_MODES[game_mode] == mode
    end
  end

  def difficulty
    DIFFICULTIES[difficulty_level]
  end

  DIFFICULTIES.each do |difficulty|
    define_method("#{difficulty}?") do
      DIFFICULTIES[difficulty_level] == difficulty
    end
  end


# Players

  def creator=(creator)
    write_attribute :creator_id, creator.id
    add_op(creator)
  end


  def add_member(user)
    memberships.find_or_create_by(user: user)
  end

  def add_op(user)
    m = add_member(user)
    m.op!
  end

  def member?(user)
    memberships.where(user_id: user.id).exists?
  end

  def op?(user)
    memberships.ops.where(user_id: user.id).exists?
  end

  def ops
    memberships.ops.map(&:user)
  end

  def members
    memberships.map {|m| m.user}
  end

  def players
    User.find(current_player_ids)
  end

  def offline_players
    User.find(memberships.map {|m| m.user_id} - current_player_ids)
  end

# Communication

  def record_event!(type, attrs)
    event = type.new(attrs)
    self.events.push(event) if event.valid?
    event
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


# Maps

  # Does a map exist *at all*
  def map?
    mapped? or (clone? and parent.map?)
  end

  # Has the world been mapped personally
  def mapped?
    not last_mapped_at.nil?
  end

  def map_assets_url
    if mapped?
      File.join ENV['WORLD_MAPS_URL'], id.to_s
    elsif cloned?
      parent.map_assets_url
    end
  end


# Uploads

  def upload_filename_prefix
    [creator.safe_username, creator.id, Time.now.strftime('%Y%m%d%H%M%S'), nil].join('-')
  end

# Cloning

  def cloned?
    self.parent
  end

  def cloned_world cloning_user
    children.where(creator_id: cloning_user.id).first
  end

  def clone_world cloner
    World.new   parent: self,
               creator: cloner,
                  name: name,
                  seed: seed,
             game_mode: game_mode,
      difficulty_level: difficulty_level,
       world_data_file: world_data_file
  end


# Other

  def to_param
    slug.to_param
  end

  def pusher_key
    "#{collection.name.downcase}-#{id}"
  end

  def redis_key
    "#{collection.name.downcase}:#{id}"
  end

  def current_player_ids
    REDIS.smembers("#{redis_key}:connected_players").map {|id| BSON::ObjectId(id)}
  end

private

  def pusher_channel
    Pusher[pusher_key]
  end

  def send_stdin(str)
    world_data = REDIS.hget "worlds:running", id
    if world_data
      instance_id = JSON.parse(world_data)['instance_id']
      REDIS.publish("workers:#{instance_id}:worlds:#{id}:stdin", str)
    end
  end

end
