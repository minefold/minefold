class Activity
  include MongoMapper::Document

  key :user, Hash
  key :context, Hash
  key :context_type, String
  key :action, String

  key :msg, String

  timestamps!

  def context=(value)
    if value.is_a?(Hash)
      super
    else
      self.context_type = value.class.name
      super(value.to_mongo)
    end
  end

  def user=(value)
    if value.is_a?(User)
      super id: value.id, username: value.username
    else
      super
    end
  end

  def self.chatted(user, world, msg)
    create(user: user, context: world, action: 'chat', msg: msg)
  end

end
