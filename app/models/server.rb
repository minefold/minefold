class Server < ActiveRecord::Base
  include Concerns::Redis

  attr_accessible :name, :description, :funpack_id, :shared, :settings

  acts_as_paranoid

  belongs_to :creator, class_name: 'User', :inverse_of => :created_servers

  belongs_to :funpack
  validates_presence_of :funpack

  has_and_belongs_to_many :watchers, class_name: 'User', uniq: true

  has_and_belongs_to_many :watchers,
    class_name: 'User',
    join_table: 'watchers',
    uniq: true

  has_and_belongs_to_many :starrers,
    class_name: 'User',
    join_table: 'stars',
    uniq: true

  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships

  validates_presence_of :name

  def initialize(*args, &blk)
    super
    self.settings = {}
  end

  has_many :votes, :dependent => :destroy

  def count_online_players
    PartyCloud.count_players_online(party_cloud_id)
  end


  serialize :settings, JSON

  has_many :posts, order: 'created_at DESC', :dependent => :destroy

  has_one :world, order: 'updated_at ASC', :dependent => :destroy

  has_many :sessions, :class_name => 'ServerSession' do

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
    if game.routing?
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

  # TODO remove this with new auth stuff
  before_create :whitelist_creator

  def whitelist_creator
    creator_account = creator.accounts.mojang.first

    creator_uid = creator_account ? creator_account.uid : creator.username

    settings['whitelist'] ||= creator_uid
    settings['ops'] ||= creator_uid
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


  def activity_stream
    @activity_stream ||= ActivityStream.new(self, $redis)
  end

  after_create :create_activity

  def create_activity
    Activities::CreatedServer.publish(self)
  end

  after_create :add_creator_to_watchers

  def add_creator_to_watchers
    self.watchers << creator
  end

end
