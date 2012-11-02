class Funpack < ActiveRecord::Base
  attr_accessible :name, :game, :creator

  belongs_to :creator, class_name: 'User'
  belongs_to :game
  
  has_many :servers
end
