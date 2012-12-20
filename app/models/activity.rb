class Activity < ActiveRecord::Base

  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :target, polymorphic: true

  after_create :publish_target

  after_create :broadcast_async

  def self.publish(*args)
    a = self.for(*args)
    a.save
    a
  end

  def score
    created_at.to_i
  end

  def interested
    [actor].compact
  end

  def publish(obj)
    stream = ActivityStream.new(obj, $redis)
    stream.add(self)
  end

  def publish_target
    publish(self.target)
  end

  def broadcast
    interested.each do |obj|
      publish(obj)
    end
  end

  def broadcast_async
    Resque.enqueue(BroadcastActivityJob, self.class.name, id)
  end

  def to_partial_path
    File.join('activities', self.class.name.demodulize.underscore)
  end

end
