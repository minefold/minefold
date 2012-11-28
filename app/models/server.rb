class Server < ActiveRecord::Base
  include Concerns::Redis

  attr_accessible :name, :funpack_id, :shared, :settings

  acts_as_paranoid

  belongs_to :creator, class_name: 'User', :inverse_of => :created_servers

  belongs_to :funpack
  validates_presence_of :funpack

  default_scope includes(:funpack => :game)

  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  validates_presence_of :name

  def initialize(*args, &blk)
    super
    self.settings = {}
  end


  serialize :settings, JSON

  has_many :comments, order: 'created_at DESC', :dependent => :destroy

  has_one :world, order: 'updated_at ASC'

  has_many :sessions do

    def current
      active.first_or_initialize
    end

    def current?
      active.exists?
    end

  end

  # Using a method instead of `has_one :game, :through => :funpack`. This field should be read only.
  def game
    funpack.game
  end

  def state
    if shared?
      :shared
    elsif sessions.current? and sessions.current.started_at.nil?
      :starting
    elsif sessions.current? and sessions.current.started_at?
      :up
    else
      :stopped
    end
  end

  def up?
    shared? or state == :up
  end

  [:starting, :stopped].each do |s|
    define_method("#{s}?") do
      self.state == s
    end
  end


  def normal?
    not shared?
  end

  def address
    [host, port].compact.join(':')
  end

  after_create :create_party_cloud_server

  def create_party_cloud_server
    PartyCloud.create_server(id)
  end

  after_create :allocate_shared_host!, :create_party_cloud_server

  def allocate_shared_host!
    if shared? and not host?
      self.host = [self.id.to_s, 'foldserver', 'com'].join('.')
      save!
    end
  end


  def redis_watchers_key
    "#{typed_redis_key}:watchers"
  end

  # before_destroy :clear_associated_watchers
  #
  # def clear_associated_watchers
  #   $redis.smembers(redis_watchers_key).each do |id|
  #     $redis.srem "user:#{id}:watching", redis_key
  #   end
  # end

  # TODO HACK!
  # after_initialize :set_default_settings
  #
  # def set_default_settings
  #   self.settings ||= {
  #     'game_mode' => '0',
  #     'difficulty' => '1',
  #     'pvp' => '1',
  #     'spawn_monsters' => '1',
  #     'spawn_animals' => '1',
  #     'spawn_npcs' => '1',
  #     'allow_nether' => '1',
  #     'control_blocks' => '1'
  #   }
  # end

end
