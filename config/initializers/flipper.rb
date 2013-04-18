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

Flipper.register(:recent_users) do |actor|
  actor.created_at > Time.parse('2013-04-16')
end

Flipper.register(:prepaid_users) do |actor|
  actor.created_at <= Time.parse('2013-04-16')
end

# --

$flipper[:unpublished_funpacks].enable $flipper.group(:admins)
$flipper[:subscriptions].enable $flipper.group(:admins)
$flipper[:subscriptions].enable $flipper.group(:recent_users)
$flipper[:prepaid].enable $flipper.group(:prepaid_users)
