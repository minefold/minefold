class Server < ActiveRecord::Base
  attr_accessible :name, :funpack_id, :super_server, :settings

  belongs_to :creator, class_name: 'User'

  belongs_to :funpack
  validates_presence_of :funpack
  
  default_scope includes(:funpack => :game)

  has_many :memberships
  has_many :users, through: :memberships

  validates_presence_of :name

  store :settings
  
  has_many :comments, order: 'created_at DESC'
  
  has_one :world, order: 'updated_at ASC'
  
  def state
    if super_server?
      :super
    else
      # TODO Check the PartyCloud
      @tmp_state ||= rand(2).zero? ? :up : :stopped
      
    end
  end
  
  def running?
    state == :super or state == :up
  end
  
  def uptime
    10.minutes
  end
  
  def normal?
    not super_server?
  end
  
  def address
    "#{id}.pluto.minefold.com"
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
