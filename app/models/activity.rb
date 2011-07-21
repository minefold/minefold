class Activity < WallItem
  include MongoMapper::Document
  key :action,      String
  key :count,       Integer, default: 0
  timestamps!

  def self.connect(user, world)
    create(user: user, wall: world, action: 'connected')
  end

  def self.disconnect(user, world)
    create(user: user, wall: world, action: 'disconnected')
  end

end
