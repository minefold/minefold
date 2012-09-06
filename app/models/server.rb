class Server < ActiveRecord::Base
  attr_accessible :name, :funpack_id, :individual, :settings

  belongs_to :creator, class_name: 'User'

  belongs_to :funpack
  validates_presence_of :funpack

  has_many :memberships
  has_many :users, through: :memberships


  validates_presence_of :name

  # mount_uploader :pic, PictureUploader


  # Minecraft Specific Server stuff

  store :settings


  # def user_whitelisted?(username)
  # end
  #
  # def user_baned?(username)
  # end
  #
  # def user_opped?(username)
  # end
  #
  # def whitelist_user(username)
  # end
  #
  # def ban_user(username)
  # end
  #
  # def pardon_user(username)
  # end
  #
  # def op_user(username)
  # end
  #
  # def deop_user(username)
  # end
  #
  #
  # store :map_markers
  #
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

end
