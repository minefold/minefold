class Game < ActiveRecord::Base
  attr_accessible :name, :individual

  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :funpacks

  def settings_partial
    partial_name = name.downcase.gsub(/\W/, '_')

    "games/settings/#{partial_name}"
  end

end
