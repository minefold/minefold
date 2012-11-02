class Server < ActiveRecord::Base
  attr_accessible :name, :funpack_id, :super_server, :settings

  acts_as_paranoid

  belongs_to :creator, class_name: 'User'

  belongs_to :funpack
  validates_presence_of :funpack

  default_scope includes(:funpack => :game)

  has_many :memberships
  has_many :users, :through => :memberships

  validates_presence_of :name

  store :settings

  has_many :comments, order: 'created_at DESC'

  has_one :world, order: 'updated_at ASC'


  # Using a method instead of `has_one :game, :through => :funpack`. This field should be read only.
  def game
    funpack.game
  end

  def state
    if super_server?
      :super
    elsif start_at.past? and stop_at.future?
      :up
    else
      :stopped
    end
  end

  def up?
    state == :super or state == :up
  end

  alias_method :running?, :up?

  def uptime
    (Time.now - start_at).ceil
  end

  def ttl
    (stop_at - Time.now).ceil
  end

  def normal?
    not super_server?
  end

  def address
    if super_server?
      "#{id}.pluto.minefold.com"
    else
      "#{host}:#{port}"
    end
  end

  def start!(ttl = nil)
    # args = {
    #   server_id: self.party_cloud_id,
    #   ttl: ttl,
    #   force: false
    # }

    # PartyCloud.start_world
    # $partycloud.lpush 'StartWorldJob', [funpack.party_cloud_id, settings, args]
  end

end
