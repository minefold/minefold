class ActivityStream

  def self.for(model)
    new(model)
  end

  def intialize(model)
    @model = model
  end

  def add
  end

  def key
    ['activitystream', model.redis_key]
  end

end
