# Updates memberships to the new format

World.all.each do |world|
  # Some worlds don't have creators
  if world.creator.nil?
    world.destroy
    next
  end

  world.unset :last_backup
  world.unset :latest_backup

  world.unset :whitelisted_player_ids


  # Store less information by remove 'player' roles

  world.memberships.each do |membership|
    membership.unset(:role) unless membership.role == 'op'
  end

  next if world.valid?


  # Ensures memberships are unique

  raw_memberships = world.attributes['memberships']
    .group_by {|m| m['user_id'] }
    .inject([]) {|memberships, (user_id, attrs)|
      membership = attrs.each_with_object({}) {|o, obj| obj.merge!(o)}
      membership['user_id'] ||= world.creator_id
      memberships << membership

      memberships
    }

  world.update_attribute :memberships, raw_memberships

end

