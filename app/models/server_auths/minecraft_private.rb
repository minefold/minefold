class ServerAuths::MinecraftPrivate < ServerAuth

  def setup?
    server.settings and
    (server.settings['whitelist'].nil? or server.settings['ops'].nil?)
  end

  def setup
    server.settings['whitelist'] ||= ''
    server.settings['ops'] ||= server.creator.accounts.mojang.pluck(:uid) || ''
  end

  def persist
    members_to_remove.each do |user|
      server.members.delete(user)
    end

    members_to_add.each do |user|
      server.members << user
    end
  end

  def can_play?(user)
    server.members.include?(user)
  end


# private

  def members_to_add
    members_from_settings - current_members
  end

  def members_to_remove
    current_members - members_from_settings
  end

  def members_from_settings
    user_ids = Accounts::Mojang
      .where(uid: usernames)
      .where("user_id IS NOT NULL")
      .pluck(:user_id)

    User.where(id: user_ids)
  end

  def current_members
    server.members
  end

  def usernames
    server.settings['whitelist'].split(/\n|\r\n/) | server.settings['ops'].split(/\n|\r\n/)
  end

end
