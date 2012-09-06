class Game < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :name, :individual

  validates_uniqueness_of :name
  validates_presence_of :name

  friendly_id :name, :use => :slugged

  has_many :funpacks

  def settings_partial
    partial_name = name.downcase.gsub(/\W/, '_')

    "games/settings/#{partial_name}"
  end

end
