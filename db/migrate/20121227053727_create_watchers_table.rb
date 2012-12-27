class CreateWatchersTable < ActiveRecord::Migration

  def change
    create_table :servers_users, id: false do |t|
      t.references :user
      t.references :server
    end

    Server.find_each do |server|
      whitelist = (server.settings['whitelist'] || "").split(/\r\n|\n/)
      ops = (server.settings['ops'] || "").split(/\r\n|\n/)

      users = [server.creator] + (whitelist | ops).map {|username|
        account = Accounts::Mojang.where(uid: username).first
        account && account.user
      }.compact.uniq

      users.each do |user|
        server.watchers << user
      end
    end

  end

end
