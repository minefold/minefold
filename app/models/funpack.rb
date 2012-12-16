class Funpack < ActiveRecord::Base
  attr_accessible :name, :game, :creator, :info_url, :description, :party_cloud_id, :inports

  belongs_to :creator, class_name: 'User'
  belongs_to :game

  has_many :servers

  def settings
    JSON.load(Rails.root.join('config', 'minecraft.json'))
  end


end
