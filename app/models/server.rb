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

  has_many :votes

  def online_players
    rand(100)
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
    game.routing? or state == :up
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

  after_create :allocate_shared_host!

  def allocate_shared_host!
    if not host?
      self.host = [self.id.to_s, 'foldserver', 'com'].join('.')
      self.save!
    end
  end

  def player_uids
    (settings['whitelist'] || '').split | (settings['ops'] || '').split
  end

  def redis_watchers_key
    "#{typed_redis_key}:watchers"
  end


  # after_create :trigger_created_activity
  #
  # def trigger_created_activity
  #   a = Activities::CreatedServer.new
  #   a.actor = creator
  #   a.target = self
  #   a.save!
  # end
  #
  # def activity_stream(n=10, offset=0)
  #   Activity.where(id: $redis.zrange("server:#{id}:stream", offset, n)).order(:created_at).reverse_order.all
  # end
  #
  # def add_activity_to_stream(activity)
  #   $redis.zadd("server:#{id}:stream", activity.score, activity.id)
  # end


  # before_destroy :clear_associated_watchers
  #
  # def clear_associated_watchers
  #   $redis.smembers(redis_watchers_key).each do |id|
  #     $redis.srem "user:#{id}:watching", redis_key
  #   end
  # end

end
