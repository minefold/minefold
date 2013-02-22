require './lib/game'
require './lib/game_library'
require 'brock'

class Funpack < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :name, :game, :creator, :info_url, :description, :party_cloud_id, :imports, :slug, :game_id, :settings_schema, :published_at

  belongs_to :creator, class_name: 'User'

  friendly_id :name, :use => :slugged

  has_many :servers

  composed_of :game, mapping: [[:game_id, :id]],
                     constructor: ->(id){ GAMES.fetch(id) }

  serialize :settings_schema, JSON

  def settings
    Brock::Schema.new(settings_schema)
  end

end
