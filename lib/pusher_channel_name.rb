class PusherChannelName

  attr_reader :object

  def initialize(object, private=false)
    @object = object
    @private = private
  end

  def private?
    @private
  end

  def to_s
    if private?
      "private-#{object.class.name}-#{object.id}"
    else
      "#{object.class.name}-#{object.id}"
    end
  end

end
