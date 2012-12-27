class CreateWatchersTable < ActiveRecord::Migration

  def change
    create_table :servers_users, id: false do |t|
      t.references :user
      t.references :server
    end

    Server.find_each do |server|
      whitelist = (server.settings['whitelist'] || "").split(/\r\n|\n/)
      ops = (server.settings['ops'] || "").split(/\r\n|\n/)

      (whitelist | ops).each do |username|
        account = Accounts::Mojang.where(uid: username).first
        if account && account.user and !account.user.watching.include?(server)
          account.user.watching << server
        end
      end
    end

  end

end
