class Server < ActiveRecord::Base

  belongs_to :creator, class_name: 'User'

  belongs_to :funpack
  validates_presence_of :funpack

  has_many :memberships
  has_many :users, through: :memberships

  #
  # mount_uploader :pic, PictureUploader
  #
  #
  # # Minecraft Specific Server stuff
  #
  # store :settings, accessors: [ :game_mode, :level_type, :seed, :difficulty,
  #                               :pvp, :spawn_monsters, :spawn_animals,
  #                               :generate_structures, :spawn_npcs, :whitelist,
  #                               :blacklist, :ops ]
  #
  #
  # GAME_MODES = [:survival, :creative]
  # LEVEL_TYPES = %w(DEFAULT FLAT LARGEBIOMES)
  # DIFFICULTIES = [:peaceful, :easy, :normal, :hard]
  #
  # validates_numericality_of :game_mode,
  #   only_integer: true,
  #   greater_than_or_equal_to: 0,
  #   less_than: GAME_MODES.size
  #
  # validates_numericality_of :difficulty,
  #   only_integer: true,
  #   greater_than_or_equal_to: 0,
  #   less_than: DIFFICULTIES.size
  #
  #
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
