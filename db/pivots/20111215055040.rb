# Moves embedded wall_items into their own "events" collection
# This means that firstly the worlds will be quicker to fetch, but it also means that it's easier to truncate walls. Walls should be seen as "streams".

World.all.each do |world|
  next unless world['wall_items']

  log "copying #{world['wall_items'].length} wall_items for #{world.name}"

  world['wall_items'].each do |item|
    next unless item['_type'] == 'Chat' and item['user_id']

    begin
      source = User.find(item['user_id'])
    rescue Mongoid::Errors::DocumentNotFound
      next
    end

    Chat.create(
      source: source,
      target: world,
      text: item['raw'],
      created_at: item['created_at']
    )
  end

  log "unsetting wall_items for #{world.name}"

  world.unset :wall_items
end
