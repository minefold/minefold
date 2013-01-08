class Funpack < ActiveRecord::Base
  extend FriendlyId
  attr_accessible :name, :game, :creator, :info_url, :description, :party_cloud_id, :imports, :slug

  belongs_to :creator, class_name: 'User'
  belongs_to :game

  friendly_id :name, :use => :slugged

  has_many :servers

  def settings
    JSON.load(Rails.root.join('config', 'minecraft.json'))
  end

  def default_settings
    {}
  end

end
