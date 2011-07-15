class Activity
  include MongoMapper::Document

  key :user,        Hash

  key :target,      Hash
  key :target_type, String

  key :context,      Hash
  key :context_type, String

  key :action,      String
  key :count,       Integer, default: 0

  timestamps!

  def user=(value)
    if value.is_a?(User)
      super(id: value.id, username: value.username)
    else
      super
    end
  end

  def target=(value)
    if value.is_a?(Hash)
      super
    else
      self.target_type = value.class.name
      super(value.to_mongo)
    end
  end

  def context=(value)
    if value.is_a?(Hash)
      super
    else
      self.context_type = value.class.name
      super(value.to_mongo)
    end
  end

end
