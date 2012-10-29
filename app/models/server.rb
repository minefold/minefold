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
  
  has_many :comments, :order => 'created_at DESC'
  
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
  
  def start!(duration)
    resp = RestClient.post("http://api.partycloud.com/v1/worlds/#{id}/start")
    
    resp.ok?
  end

  
  # This is in the absense of having an actual World model. We stuff everything into the Server model and then pull it out when nessecary.
  def world_data
    {
      server_id: id,
      last_mapped_at: last_mapped_at,
      map_markers: [],
      partycloud_id:  partycloud_id
    }
  end

end
