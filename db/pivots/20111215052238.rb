# Moves credit_events out of User

User.all.each do |user|
  next unless user['credit_events']

  log "copying #{user['credit_events'].length} credit_events for #{user.safe_username}"

  user['credit_events'].each do |event|
    CreditTrail.create(
      user: user,
      delta: event['delta'],
      created_at: event['created_at']
    )
  end

  log "unsetting credit_events for #{user.safe_username}"

  user.unset :credit_events
end
