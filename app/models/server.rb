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

  # store :map_markers
  #
  # # Does a map exist *at all*
  # def map?
  #   mapped? # or (clone? and parent.map?)
  # end
  #
  # # Has the world been mapped personally
  # def mapped?
  #   not last_mapped_at.nil?
  # end
  #
  # # The base location of the map data
  # def map_assets_url
  #   case
  #   when mapped?
  #     File.join ENV['WORLD_MAPS_URL'], id.to_s
  #   # when clone?
  #   #   parent.map_assets_url
  #   end
  # end
  
  after_create do |server|
    Mixpanel.engage_async user.id, '$add' => {
      'servers' => 1
    }
  end

end
