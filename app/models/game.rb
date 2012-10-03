class Game < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :name, :super_servers, :persistant_data

  validates_uniqueness_of :name
  validates_presence_of :name

  friendly_id :name, :use => :slugged

  has_many :funpacks

  def settings_partial
    partial_name = name.downcase.gsub(/\W/, '_')

    "games/settings/#{partial_name}"
  end
  
  
  # Ideally this should be extracted out into "capabilities". Things should be turned on and off based on the capabilities of the game. In this case it would be persistant & mappable.
  def minecraft?
    self.name == 'Minecraft'
  end
  
  def self.servers_count
    joins(:funpacks => :servers).count
  end

end
