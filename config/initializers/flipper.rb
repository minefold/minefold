redis = Redis::Namespace.new(:flipper, redis: $redis)
adapter = Flipper::Adapters::Redis.new(redis)

$flipper = Flipper.new(adapter)

Flipper.register(:all) do |actor|
  true
end

Flipper.register(:admins) do |actor|
  actor.respond_to?(:admin?) && actor.admin?
end

Flipper.register(:beta) do |actor|
  actor.respond_to?(:beta?) && actor.beta?
end

# --

$flipper[:access_controls].enable $flipper.group(:admins)
$flipper[:unpublished_funpacks].enable $flipper.group(:admins)
$flipper[:subscriptions].enable $flipper.group(:admins)