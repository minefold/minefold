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

  # TODO Actually do this validation
  # validates_presence_of :host, :if => :shared?
  validates_uniqueness_of :host, allow_nil: true

  # Using a method instead of `has_one :game, :through => :funpack`. This field should be read only.
  def game
    funpack.game
  end

  def run?
    start_at? and stop_at?
  end

  def state
    if shared?
      :shared
    elsif run? and start_at.past? and stop_at.future?
      :up
    else
      :stopped
    end
  end

  def up?
    state == :shared or state == :up
  end

  alias_method :running?, :up?

  def uptime
    (Time.now - start_at).ceil
  end

  def ttl
    (stop_at - Time.now).ceil
  end

  def normal?
    not shared?
  end

  def address
    [host, port].compact.join(':')
  end

  def start!(schedule_stop_at)
    if schedule_stop_at
      self.stop_at = schedule_stop_at
      save!
    end

    PartyCloud.start_server party_cloud_id, funpack.party_cloud_id, settings
    # TODO stop the server
  end

  def started!(host, port)
    self.start_at = Time.now
    self.host = host
    self.port = port
    save!
  end

  def stopped!
    self.start_at = nil
    self.stop_at = nil
    save!
  end

  after_create :allocate_shared_host!, :create_party_cloud_server

  def allocate_shared_host!
    if shared?
      self.host = [self.id.to_s, 'foldserver', 'com'].join('.')
      save!
    end
  end

  def create_party_cloud_server
    PartyCloud.create_server id
  end


  def redis_watchers_key
    "#{typed_redis_key}:watchers"
  end

  before_destroy :clear_associated_watchers

  def clear_associated_watchers
    $redis.smembers(redis_watchers_key).each do |id|
      $redis.srem "user:#{id}:watching", redis_key
    end
  end

end
