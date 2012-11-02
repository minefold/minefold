class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  attr_accessible :game, :uid, :created_at, :updated_at

  validates_uniqueness_of :uid, :scope => :game_id
  
  # TODO Test
  def self.minecraft
    includes(:game).where('games.name' => 'Minecraft')
  end
  
end
