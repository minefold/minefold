require 'state_machine/core'
require './lib/redis_key'
require './lib/server_address'
# require './lib/game_access_policy'

class Server < ActiveRecord::Base
  extend StateMachine::MacroMethods
  include Concerns::MaxPlayers

  attr_accessible :name, :description, :funpack_id, :shared, :settings
  attr_accessible :access_policy_id

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
  validates_length_of :name, in: 2...255

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

  delegate :persistent?, :to => :funpack

  States = {
    idle: 0,
    starting: 1,
    up: 2,
    stopping: 3
  }

  validates_presence_of :state

  state_machine :initial => :idle do

    States.each do |name, value|
      state(name, value: value)
    end

    event :start do
      transition all => :starting
    end

    event :started do
      transition all => :up
    end

    event :stop do
      transition all => :stopping
    end

    before_transition all => [:stopping, :idle], :do => :clear_host_and_port

    event :stopped do
      transition all => :idle
    end
  end

  def address
    ServerAddress.new(self)
  end

  # TODO

  def clear_host_and_port
    self.host, self.port = nil, nil
  end

  def player_uids
    (settings['whitelist'] || '').split | (settings['ops'] || '').split
  end

  def player_accounts
    # TODO should work for other games
    # need mapping from funpack => account type
    accounts = Accounts::Mojang.where('uid in (?)', player_uids).all

    player_uids.each_with_object({}) do |uid, h|
      h[uid] = accounts.find{|a| a.uid == uid }
    end
  end

  def redis_watchers_key
    RedisKey.new(self, :watchers).to_s
  end

  def activity_stream
    @activity_stream ||= ActivityStream.new(self, $redis)
  end

  def available_access_policies
    funpack.access_policies
  end

  def access_policy
    funpack.access_policies.fetch(self.access_policy_id).new(self)
  end

  def playable?
    persistent? || up?
  end

end
